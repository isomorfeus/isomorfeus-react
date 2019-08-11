module Isomorfeus
  module ReactViewHelper
    def mount_component(component_name, props = {}, asset = 'application_ssr.js')
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
        javascript = "global.Opal.Isomorfeus['$force_init!']();\n"
        if props.key?(:location)
          javascript << <<~JAVASCRIPT
            global.Opal.Isomorfeus.TopLevel["$ssr_route_path="]('#{props[:location]}');
          JAVASCRIPT
        end
        if props.key?(:location_host) && props.key?(:location_scheme)
          ws_scheme = props[:location_scheme] == 'https:' ? 'wss:' : 'ws:'
          javascript << <<~JAVASCRIPT
            global.Opal.Isomorfeus.TopLevel["$transport_ws_url="]('#{ws_scheme}#{props[:location_host]}#{Isomorfeus.api_websocket_path}');
            if (typeof global.Opal.Isomorfeus.Transport !== 'undefined') { global.Opal.Isomorfeus.Transport.$connect(); }
          JAVASCRIPT
        end
        javascript << <<~JAVASCRIPT
          var rendered_tree = global.Opal.Isomorfeus.TopLevel.$render_component_to_string('#{component_name}', #{Oj.dump(props, mode: :strict)})
          var transport_busy = false;
          if (typeof global.Opal.Isomorfeus.Transport !== 'undefined') { 
            if (typeof global.Opal.Isomorfeus.Transport['$was_busy?'] !== 'undefined') { transport_busy = global.Opal.Isomorfeus.Transport['$was_busy?'](); }
            else { transport_busy = global.Opal.Isomorfeus.Transport['$busy?'](); }
            if (!transport_busy) { global.Opal.Isomorfeus.Transport.$disconnect(); }
          }
          if (transport_busy) {
            return ['', '', transport_busy]
          } else {
            var application_state = global.Opal.Isomorfeus.store.native.getState();
            return [rendered_tree, application_state, transport_busy];
          }
        JAVASCRIPT
        # execute first render pass
        rendered_tree, application_state, transport_busy = Isomorfeus.ssr_contexts[thread_id_asset].exec(javascript)

        if transport_busy
          # wait for transport requests to finish
          start_time = Time.now
          while transport_busy
            break if (Time.now - start_time) > 10
            sleep 0.01
            transport_busy = Isomorfeus.ssr_contexts[thread_id_asset].exec('return global.Opal.Isomorfeus.Transport["$busy?"]()')
          end
          # build javascript for second render pass
          javascript = <<~JAVASCRIPT
            var rendered_tree = global.Opal.Isomorfeus.TopLevel.$render_component_to_string('#{component_name}', #{Oj.dump(props, mode: :strict)})
            var application_state = global.Opal.Isomorfeus.store.native.getState();
            var transport_busy = false;
            if (typeof global.Opal.Isomorfeus.Transport !== 'undefined') { 
              transport_busy = global.Opal.Isomorfeus.Transport['$busy?']();
              global.Opal.Isomorfeus.Transport.$disconnect();
            }
            return [rendered_tree, application_state, transport_busy];
          JAVASCRIPT
          # execute second render pass
          rendered_tree, application_state, _transport_busy = Isomorfeus.ssr_contexts[thread_id_asset].exec(javascript)
        end

        # build result
        render_result << " data-iso-state='#{Oj.dump(application_state, mode: :strict)}'>"
        render_result << rendered_tree
      else
        render_result << '>'
      end
      render_result << '</div>'
      render_result
    end
  end
end