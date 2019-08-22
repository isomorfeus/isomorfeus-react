module Isomorfeus
  module ReactViewHelper
    def mount_component(component_name, props = {}, asset = 'application_ssr.js')
      @ssr_response_status = nil
      thread_id_asset = "#{Thread.current.object_id}#{asset}"
      render_result = "<div data-iso-env=\"#{Isomorfeus.env}\" data-iso-root=\"#{component_name}\" data-iso-props='#{Oj.dump(props, mode: :strict)}'"
      if Isomorfeus.server_side_rendering

        # initialize speednode context
        unless Isomorfeus.ssr_contexts.key?(thread_id_asset)
          asset_file_name = OpalWebpackLoader::Manifest.lookup_path_for(asset)
          asset_path = File.join('public', asset_file_name)
          Isomorfeus.ssr_contexts[thread_id_asset] = ExecJS.permissive_compile(File.read(asset_path))
        end

        # build javascript for rendering first pass
        javascript = <<~JAVASCRIPT
          global.FirstPassFinished = false;
          global.Opal.Isomorfeus['$env=']('#{Isomorfeus.env}');
          if (typeof global.Opal.Isomorfeus.$negotiated_locale === 'function') {
            global.Opal.Isomorfeus["$negotiated_locale="]('#{props[:locale]}');
          }
          global.Opal.Isomorfeus['$force_init!']();
          global.Opal.Isomorfeus['$ssr_response_status='](200);
          global.Opal.Isomorfeus.TopLevel['$ssr_route_path=']('#{props[:location]}');
        JAVASCRIPT

        # if location_host and scheme are given and if Transport is loaded, connect and then render, otherwise do not render
        ws_scheme = props[:location_scheme] == 'https:' ? 'wss:' : 'ws:'
        location_host = props[:location_host] ? props[:location_host] : 'localhost'
        api_ws_path = Isomorfeus.respond_to?(:api_websocket_path) ? Isomorfeus.api_websocket_path : ''
        transport_ws_url = ws_scheme + location_host + api_ws_path
        javascript << <<~JAVASCRIPT
          var api_ws_path = '#{api_ws_path}';
          if (typeof global.Opal.Isomorfeus.Transport !== 'undefined' && api_ws_path !== '') {
            global.Opal.Isomorfeus.TopLevel["$transport_ws_url="]("#{transport_ws_url}");
            global.Opal.send(global.Opal.Isomorfeus.Transport.$promise_connect(), 'then', [], ($$1 = function(){
              try {
                global.Opal.Isomorfeus.TopLevel.$render_component_to_string('#{component_name}', #{Oj.dump(props, mode: :strict)});
                global.FirstPassFinished = 'transport';
              } catch (e) { global.FirstPassFinished = 'transport'; }
            }, $$1.$$s = this, $$1.$$arity = 0, $$1))
          } else { return global.FirstPassFinished = true; };
        JAVASCRIPT

        # execute first render pass
        first_pass_skipped = Isomorfeus.ssr_contexts[thread_id_asset].exec(javascript)

        # wait for first pass to finish
        unless first_pass_skipped
          first_pass_finished = Isomorfeus.ssr_contexts[thread_id_asset].exec('return global.FirstPassFinished')
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
        javascript = <<~JAVASCRIPT
          var rendered_tree = global.Opal.Isomorfeus.TopLevel.$render_component_to_string('#{component_name}', #{Oj.dump(props, mode: :strict)})
          var application_state = global.Opal.Isomorfeus.store.native.getState();
          if (typeof global.Opal.Isomorfeus.Transport !== 'undefined') { global.Opal.Isomorfeus.Transport.$disconnect(); }
          return [rendered_tree, application_state, global.Opal.Isomorfeus['$ssr_response_status']()];
        JAVASCRIPT

        # execute second render pass
        rendered_tree, application_state, @ssr_response_status = Isomorfeus.ssr_contexts[thread_id_asset].exec(javascript)

        # build result
        render_result << " data-iso-nloc='#{props[:locale]}' data-iso-state='#{Oj.dump(application_state, mode: :strict)}'>"
        render_result << rendered_tree
      else
        render_result << " data-iso-nloc='#{props[:locale]}'>"
      end
      render_result << '</div>'
      render_result
    end

    def ssr_response_status
      @ssr_response_status || 200
    end
  end
end
