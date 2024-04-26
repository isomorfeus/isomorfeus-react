module React
  module DOM
    class << self
      def create_portal(child, container)
        # container is a native DOM node
        `Opal.global.ReactDOM.createPortal(child, container)`
      end

      def find_dom_node(native_react_component)
        `Opal.global.ReactDOM.findDOMNode(native_react_component)`
      end

      def hydrate(native_react_element, container, &block)
        # container is a native DOM element
        if block_given?
          `Opal.global.ReactDOM.hydrate(native_react_element, container, function() { block.$call() })`
        else
          `Opal.global.ReactDOM.hydrate(native_react_element, container)`
        end
      end

      def render(native_react_element, container, &block)
        # container is a native DOM element
        if block_given?
          `Opal.global.ReactDOM.render(native_react_element, container, function() { block.$call() })`
        else
          `Opal.global.ReactDOM.render(native_react_element, container)`
        end
      end

      def unmount_component_at_node(element_or_query)
        if `(typeof element_or_query === 'string')` || (`(typeof element_or_query.$class === 'function')` && element_or_query.class == String)
          element = `document.body.querySelector(element_or_query)`
        elsif `(typeof element_or_query.$is_a === 'function')` && element_or_query.is_a?(Browser::Element)
          element = element_or_query.to_n
        else
          element = element_or_query
        end
        `Opal.global.ReactDOM.unmountComponentAtNode(element)`
      end
    end
  end
end