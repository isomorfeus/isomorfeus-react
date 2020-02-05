module Isomorfeus
  module ReactViewHelper
    def cached_mount_component(component_name, props = {}, asset = 'application_ssr.js')
      key = "#{component_name}#{props}#{asset}"
      if Isomorfeus.production? && component_cache.key?(key)
        render_result = component_cache[key][:render_result]
        @ssr_response_status = component_cache[key][:ssr_response_status]
        @sst_styles = component_cache[key][:ssr_styles]
      else
        render_result = mount_component(component_name, props, asset)
        status = ssr_response_status
        if status >= 200 && status < 300
          component_cache[key] = { render_result: render_result, ssr_response_status: status, ssr_styles: ssr_styles }
        end
      end
      render_result
    end

    def mount_component(component_name, props = {}, asset = 'application_ssr.js', static: false)
      @ssr_response_status = nil
      @ssr_styles = nil
      thread_id_asset = "#{Thread.current.object_id}#{asset}"
      render_result = "<div data-iso-env=\"#{Isomorfeus.env}\" data-iso-root=\"#{component_name}\" data-iso-props='#{Oj.dump(props, mode: :strict)}'"
      if Isomorfeus.server_side_rendering

        if Isomorfeus.development?
          # always create a new context, effectively reloading code
          # delete the existing context first, saves memory
          if Isomorfeus.ssr_contexts.key?(thread_id_asset)
            uuid = Isomorfeus.ssr_contexts[thread_id_asset].instance_variable_get(:@uuid)
            runtime = Isomorfeus.ssr_contexts[thread_id_asset].instance_variable_get(:@runtime)
            runtime.vm.delete_context(uuid)
          end
          asset_path = "#{Isomorfeus.ssr_hot_asset_url}#{asset}"
          begin
            asset = Net::HTTP.get(URI(asset_path))
          rescue Exception => e
            Isomorfeus.raise_error(message: "Server Side Rendering: Failed loading asset #{asset_path} from webpack dev server. Error: #{e.message}")
          end
          if asset.strip.start_with?('<')
            Isomorfeus.raise_error(message: "Server Side Rendering: Failed loading asset #{asset_path} from webpack dev server, asset is not javascript. Did the webpack build succeed?")
          end
          begin
            Isomorfeus.ssr_contexts[thread_id_asset] = ExecJS.permissive_compile(asset)
          rescue Exception => e
            Isomorfeus.raise_error(message: "Server Side Rendering: Failed creating context for #{asset_path}. Error: #{e.message}")
          end
        else
          # initialize speednode context
          unless Isomorfeus.ssr_contexts.key?(thread_id_asset)
            asset_file_name = OpalWebpackLoader::Manifest.lookup_path_for(asset)
            asset_path = File.join('public', asset_file_name)
            Isomorfeus.ssr_contexts[thread_id_asset] = ExecJS.permissive_compile(File.read(asset_path))
          end
        end

        # build javascript for rendering first pass
        # it will initialize buffers to guard against leaks, maybe caused by previous exceptions
        javascript = <<~JAVASCRIPT
          global.Opal.React.render_buffer = [];
          global.Opal.React.active_components = [];
          global.Opal.React.active_redux_components = [];
          global.FirstPassFinished = false;
          global.Exception = false;
          global.Opal.Isomorfeus['$env=']('#{Isomorfeus.env}');
          if (typeof global.Opal.Isomorfeus.$negotiated_locale === 'function') {
            global.Opal.Isomorfeus["$negotiated_locale="]('#{props[:locale]}');
          }
          global.Opal.Isomorfeus['$force_init!']();
          global.Opal.Isomorfeus['$ssr_response_status='](200);
          global.Opal.Isomorfeus.TopLevel['$ssr_route_path=']('#{props[:location]}');
        JAVASCRIPT

        # if location_host and scheme are given and if Transport is loaded, connect and then render,
        # otherwise do not render because only one pass is required
        ws_scheme = props[:location_scheme] == 'https:' ? 'wss:' : 'ws:'
        location_host = props[:location_host] ? props[:location_host] : 'localhost'
        api_ws_path = Isomorfeus.respond_to?(:api_websocket_path) ? Isomorfeus.api_websocket_path : ''
        transport_ws_url = ws_scheme + location_host + api_ws_path
        javascript << <<~JAVASCRIPT
          let api_ws_path = '#{api_ws_path}';
          let exception;
          if (typeof global.Opal.Isomorfeus.Transport !== 'undefined' && api_ws_path !== '') {
            global.Opal.Isomorfeus.TopLevel["$transport_ws_url="]("#{transport_ws_url}");
            global.Opal.send(global.Opal.Isomorfeus.Transport.$promise_connect(), 'then', [], ($$1 = function(){
              try {
                if (#{static}) { global.Opal.Isomorfeus.TopLevel.$render_component_to_static_markup('#{component_name}', #{Oj.dump(props, mode: :strict)}); }
                else { global.Opal.Isomorfeus.TopLevel.$render_component_to_string('#{component_name}', #{Oj.dump(props, mode: :strict)}); }
                global.FirstPassFinished = 'transport';
              } catch (e) {
                global.Exception = e; 
                global.FirstPassFinished = 'transport';               
              }
            }, $$1.$$s = this, $$1.$$arity = 0, $$1))
          } else { return global.FirstPassFinished = true; };
        JAVASCRIPT

        # execute first render pass
        first_pass_skipped = Isomorfeus.ssr_contexts[thread_id_asset].exec(javascript)

        # wait for first pass to finish
        unless first_pass_skipped
          first_pass_finished, exception = Isomorfeus.ssr_contexts[thread_id_asset].exec('return [global.FirstPassFinished, global.Exception ? { message: global.Exception.message, stack: global.Exception.stack } : false ]')
          Isomorfeus.raise_error(message: "Server Side Rendering: #{exception['message']}", stack: exception['stack']) if exception
          unless first_pass_finished
            start_time = Time.now
            while !first_pass_finished
              break if (Time.now - start_time) > 10
              sleep 0.01
              first_pass_finished = Isomorfeus.ssr_contexts[thread_id_asset].exec('return global.FirstPassFinished')
            end
          end

          # wait for transport requests to finish
          if first_pass_finished == 'transport'
            transport_busy = Isomorfeus.ssr_contexts[thread_id_asset].exec('return global.Opal.Isomorfeus.Transport["$busy?"]()')
            if transport_busy
              start_time = Time.now
              while transport_busy
                break if (Time.now - start_time) > 10
                sleep 0.01
                transport_busy = Isomorfeus.ssr_contexts[thread_id_asset].exec('return global.Opal.Isomorfeus.Transport["$busy?"]()')
              end
            end
          end
        end

        # build javascript for second render pass
        # guard against leaks from first pass, maybe because of a exception
        javascript = <<~JAVASCRIPT
          global.Opal.React.render_buffer = [];
          global.Opal.React.active_components = [];
          global.Opal.React.active_redux_components = [];
          global.Exception = false;
          let rendered_tree;
          let ssr_styles;
          let component;
          if (typeof global.Opal.global.MuiStyles !== 'undefined' && typeof global.Opal.global.MuiStyles.ServerStyleSheets !== 'undefined') {
            component = '#{component_name}'.split(".").reduce(function(o, x) {
              return (o !== null && typeof o[x] !== "undefined" && o[x] !== null) ? o[x] : null;
            }, global.Opal.global)
            if (!component) { component = global.Opal.Isomorfeus.$cached_component_class('#{component_name}'); }
            try {
              let sheets = new global.Opal.global.MuiStyles.ServerStyleSheets();
              let app = global.Opal.React.$create_element(component, global.Opal.Hash.$new(#{Oj.dump(props, mode: :strict)}));
              if (#{static}) { rendered_tree = global.Opal.global.ReactDOMServer.renderToStaticMarkup(sheets.collect(app)); }
              else { rendered_tree = global.Opal.global.ReactDOMServer.renderToString(sheets.collect(app)); }
              ssr_styles = sheets.toString();
            } catch (e) {
              global.Exception = e;
            }
          } else if (typeof global.Opal.global.ReactJSS !== 'undefined' && typeof global.Opal.global.ReactJSS.SheetsRegistry !== 'undefined') {
            component = '#{component_name}'.split(".").reduce(function(o, x) {
              return (o !== null && typeof o[x] !== "undefined" && o[x] !== null) ? o[x] : null;
            }, global.Opal.global)
            if (!component) { component = global.Opal.Isomorfeus.$cached_component_class('#{component_name}'); }
            try {
              let sheets = new global.Opal.global.ReactJSS.SheetsRegistry();
              let generate_id = global.Opal.global.ReactJSS.createGenerateId();
              let app = global.Opal.React.$create_element(component, global.Opal.Hash.$new(#{Oj.dump(props, mode: :strict)}));
              let element = global.Opal.global.React.createElement(global.Opal.global.ReactJSS.JssProvider, { registry: sheets, generateId: generate_id }, app);
              if (#{static}) { rendered_tree = global.Opal.global.ReactDOMServer.renderToStaticMarkup(element); }
              else { rendered_tree = global.Opal.global.ReactDOMServer.renderToString(element); }
              ssr_styles = sheets.toString();
            } catch (e) {
              global.Exception = e;
            }
          } else {
            try {
              if (#{static}) { rendered_tree = global.Opal.Isomorfeus.TopLevel.$render_component_to_static_markup('#{component_name}', #{Oj.dump(props, mode: :strict)}); } 
              else { rendered_tree = global.Opal.Isomorfeus.TopLevel.$render_component_to_string('#{component_name}', #{Oj.dump(props, mode: :strict)}); }
            } catch (e) {
              global.Exception = e;
            }
          }
          let application_state = global.Opal.Isomorfeus.store.native.getState();
          if (typeof global.Opal.Isomorfeus.Transport !== 'undefined') { global.Opal.Isomorfeus.Transport.$disconnect(); }
          return [rendered_tree, application_state, ssr_styles, global.Opal.Isomorfeus['$ssr_response_status'](), global.Exception ? { message: global.Exception.message, stack: global.Exception.stack } : false];
        JAVASCRIPT

        # execute second render pass
        rendered_tree, application_state, @ssr_styles, @ssr_response_status, exception = Isomorfeus.ssr_contexts[thread_id_asset].exec(javascript)
        Isomorfeus.raise_error(message: exception['message'], stack: exception['stack']) if exception

        # build result
        render_result << " data-iso-hydrated='true'" if rendered_tree
        render_result << " data-iso-nloc='#{props[:locale]}'>"
        render_result << (rendered_tree ? rendered_tree : "SSR didn't work")
      else
        render_result << " data-iso-nloc='#{props[:locale]}'>"
      end
      render_result << '</div>'
      if Isomorfeus.server_side_rendering
        render_result = "<script type='application/javascript'>\nServerSideRenderingStateJSON = #{Oj.dump(application_state, mode: :strict)}\n</script>\n" << render_result
      end
      render_result
    end

    def mount_static_component(component_name, props = {}, asset = 'application_ssr.js', static: false)
      mount_component(component_name, props, asset, static: true)
    end

    def ssr_response_status
      @ssr_response_status || 200
    end

    def ssr_styles
      @ssr_styles || ''
    end

    private

    def component_cache
      @_component_cache ||= Isomorfeus.component_cache_class.new
    end
  end
end
