module Isomorfeus
  module ReactViewHelper
    def mount_component(component_name, props = {}, asset = 'application_ssr.js')
      thread_id_asset = "#{Thread.current.object_id}#{asset}"
      render_result = "<div data-iso-env=\"#{Isomorfeus.env}\" data-iso-root=\"#{component_name}\" data-iso-props='#{Oj.dump(props, mode: :strict)}'"
      if Isomorfeus.server_side_rendering
        unless Isomorfeus.ssr_contexts.key?(thread_id_asset)
          asset_file_name = OpalWebpackLoader::Manifest.lookup_path_for(asset)
          asset_path = File.join('public', asset_file_name)
          Isomorfeus.ssr_contexts[thread_id_asset] = ExecJS.permissive_compile(File.read(asset_path))
        end
        javascript = ''
        if props.key?(:location)
          javascript << <<~JAVASCRIPT
            global.Opal.Isomorfeus.TopLevel["$ssr_route_path="]('#{props[:location]}');
          JAVASCRIPT
        end
        if props.key?(:location_host) && props.key?(:location_scheme)
          ws_scheme = props[:location_scheme] == 'https:' ? 'wss:' : 'ws:'
          javascript << <<~JAVASCRIPT
            global.Opal.Isomorfeus.TopLevel["$transport_ws_url="]('#{ws_scheme}#{props[:location_host]}#{Isomorfeus.api_websocket_path}');
            if (typeof global.Opal.Isomorfeus.Transport !== 'undefined') { 
              global.Opal.Isomorfeus.Transport.$connect();
            }
          JAVASCRIPT
        end
        javascript << <<~JAVASCRIPT
          var rendered_tree = global.Opal.Isomorfeus.TopLevel.$render_component_to_string('#{component_name}', #{Oj.dump(props, mode: :strict)})
          var application_state = global.Opal.Isomorfeus.store.native.getState();
          if (typeof global.Opal.Isomorfeus.Transport !== 'undefined') { 
            global.Opal.Isomorfeus.Transport.$disconnect();
          }
          return [rendered_tree, application_state]
        JAVASCRIPT
        rendered_tree, application_state = Isomorfeus.ssr_contexts[thread_id_asset].exec(javascript)
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