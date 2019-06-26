module Isomorfeus
  class TopLevel
    class << self
      attr_accessor :ssr_route_path
      attr_accessor :transport_ws_url

      def mount!
        # nothing, but keep it for compatibility with browser
      end

      def render_component_to_string(component_name, props_json)
        # for some reason props_json arrives already decoded
        component = component_name.constantize
        unless Isomorfeus.initial_state_fetched
          Isomorfeus.initial_state_fetched = true
          Redux::Store.preloaded_state = Isomorfeus.store.get_state
        end
        Isomorfeus.force_init!
        ReactDOMServer.render_to_string(React.create_element(component, `Opal.Hash.$new(props_json)`))
      end
    end
  end
end
