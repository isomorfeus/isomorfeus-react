module React
  module ViewHelper
    def mount_component(component_name, props = {}, asset = 'web_ssr.js', static = false)
      @ssr_response_status = nil
      thread_id_asset = "#{Thread.current.object_id}#{asset}"
      render_result = if static
                        '<div>'
                      else
                        "<div data-iso-root=\"#{component_name}\" data-iso-props='#{JSON.dump(props)}'"
                      end
      if React.server_side_rendering
        # initialize speednode context
        unless React.ssr_contexts.key?(thread_id_asset)
          asset_path = File.join('public', asset_file_name)
          React.raise_error(message: "Server Side Rendering: Build asset file not found for #{asset}. Has it been build?") unless File.exist? asset_path
          React.ssr_contexts[thread_id_asset] = ExecJS.permissive_compile(File.read(asset_path))
        end

        # build javascript for rendering first pass
        # it will initialize buffers to guard against leaks, maybe caused by previous exceptions
        javascript = <<~JAVASCRIPT
          global.Opal.React.render_buffer = [];
          global.Opal.React.active_components = [];
          global.FirstPassFinished = false;
          global.Exception = false;
          global.Opal.React['$force_init!']();
          global.Opal.React['$ssr_response_status='](200);
          global.Opal.React.TopLevel['$ssr_route_path=']('#{props[:location]}');
        JAVASCRIPT

        # if location_host and scheme are given and if Transport is loaded, connect and then render,
        # otherwise do not render because only one pass is required
        ws_scheme = props[:location_scheme] == 'https:' ? 'wss:' : 'ws:'
        location_host = props[:location_host] ? props[:location_host] : 'localhost'
        javascript << <<~JAVASCRIPT
          return global.FirstPassFinished = true;
        JAVASCRIPT

        # execute first render pass
        first_pass_skipped = React.ssr_contexts[thread_id_asset].exec(javascript)

        # wait for first pass to finish
        unless first_pass_skipped
          first_pass_finished, exception = React.ssr_contexts[thread_id_asset].exec('return [global.FirstPassFinished, global.Exception ? { message: global.Exception.message, stack: global.Exception.stack } : false ]')
          React.raise_error(message: "Server Side Rendering: #{exception['message']}", stack: exception['stack']) if exception
          unless first_pass_finished
            start_time = Time.now
            while !first_pass_finished
              break if (Time.now - start_time) > 10
              sleep 0.01
              first_pass_finished = React.ssr_contexts[thread_id_asset].exec('return global.FirstPassFinished')
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
          let component;
          try {
            if (#{static}) { rendered_tree = global.Opal.React.TopLevel.$render_component_to_static_markup('#{component_name}', #{JSON.dump(props, mode: :strict)}); }
            else { rendered_tree = global.Opal.React.TopLevel.$render_component_to_string('#{component_name}', #{JSON.dump(props, mode: :strict)}); }
          } catch (e) {
            global.Exception = e;
          }
          return [rendered_tree, global.Opal.React['$ssr_response_status'](), global.Exception ? { message: global.Exception.message, stack: global.Exception.stack } : false];
        JAVASCRIPT

        # execute second render pass
        rendered_tree, @ssr_response_status, exception = React.ssr_contexts[thread_id_asset].exec(javascript)
        React.raise_error(message: exception['message'], stack: exception['stack']) if exception

        # build result
        unless static
          render_result << " data-iso-hydrated='true'" if rendered_tree
          render_result << " data-iso-nloc='#{props[:locale]}'>"
        end
        render_result << (rendered_tree ? rendered_tree : "SSR didn't work")
      else

        render_result << " data-iso-nloc='#{props[:locale]}'>" unless static
      end
      render_result << '</div>'
      render_result
    end

    def mount_static_component(component_name, props = {}, asset = 'web_ssr.js')
      mount_component(component_name, props, asset, true)
    end

    def ssr_response_status
      @ssr_response_status || 200
    end
  end
end
