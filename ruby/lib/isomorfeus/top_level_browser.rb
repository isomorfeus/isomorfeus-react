module Isomorfeus
  class TopLevel
    def self.mount!
      Isomorfeus.init
      on_ready do
        root_element = `document.querySelector('div[data-iso-root]')`
        component_name = root_element.JS.getAttribute('data-iso-root')
        component = component_name.constantize
        props_json = root_element.JS.getAttribute('data-iso-props')
        props = `Opal.Hash.$new(JSON.parse(props_json))`
        hydrated = root_element.JS.getAttribute('data-iso-hydrated')
        state_json = root_element.JS.getAttribute('data-iso-state')
        if state_json
          state = `JSON.parse(state_json)`
          Isomorfeus.store.JS[:native].JS.dispatch(`{ type: 'APPLICATION_STATE', set_state: state.application_state }`)
          Isomorfeus.store.JS[:native].JS.dispatch(`{ type: 'COMPONENT_STATE', set_state: state.component_state }`)
          Isomorfeus.store.JS[:native].JS.dispatch(`{ type: 'COMPONENT_CLASS_STATE', set_state: state.component_class_state }`)
        end
        mount_component(component, props, root_element, hydrated)
      end
    end

    def self.on_ready(&block)
      # this looks a bit odd but works across _all_ browsers, and no event handler mess
      %x{
        function run() { block.$call() };
        function ready_fun() {
          /in/.test(document.readyState) ? setTimeout(ready_fun,5) : run();
        }
        ready_fun();
      }
    end

    def self.on_ready_mount(component, props = nil, element_query = nil)
      # init in case it hasn't been run yet
      Isomorfeus.init
      on_ready do
        mount_component(component, props, element_query)
      end
    end

    def self.mount_component(component, props, element_or_query, hydrated = false)
      if `(typeof element_or_query === 'string')` || (`(typeof element_or_query.$class === 'function')` && element_or_query.class == String)
        element = `document.body.querySelector(element_or_query)`
      elsif `(typeof element_or_query.$is_a === 'function')` && element_or_query.is_a?(Browser::DOM::Node)
        element = element_or_query.to_n
      else
        element = element_or_query
      end

      Isomorfeus.top_component = if hydrated
                                   ReactDOM.hydrate(React.create_element(component, props), element)
                                 else
                                   ReactDOM.render(React.create_element(component, props), element)
                                 end
    end
  end
end
