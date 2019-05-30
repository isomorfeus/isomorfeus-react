module Isomorfeus
  module ReactViewHelper
    def mount_component(component_name, props = {}, asset = 'application_ssr.js')
      render_result = "<div data-iso-env=\"#{Isomorfeus.env}\" data-iso-root=\"#{component_name}\" data-iso-props='#{Oj.dump(props, mode: :strict)}'>"
      if Isomorfeus.server_side_rendering
        unless Isomorfeus.ssr_contexts.key?(asset)
          asset_file_name = OpalWebpackLoader::Manifest.lookup_path_for(asset)
          asset_path = File.join('public', asset_file_name)
          Isomorfeus.ssr_contexts[asset] = ExecJS.permissive_compile(File.read(asset_path))
        end
        javascript = ''
        if props.key?(:location)
          javascript << <<~JAVASCRIPT
            global.Opal.Isomorfeus.TopLevel["$ssr_route_path="]('#{props[:location]}');
          JAVASCRIPT
        end
        javascript << <<~JAVASCRIPT
          return global.Opal.Isomorfeus.TopLevel.$render_component_to_string('#{component_name}', #{Oj.dump(props, mode: :strict)})
        JAVASCRIPT
        render_result << Isomorfeus.ssr_contexts[asset].exec(javascript)
      end
      render_result << '</div>'
      render_result
    end
  end
end