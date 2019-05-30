module ReactDOM
  class << self
    def create_portal(child, container)
      # container is a native DOM node
      `Opal.global.ReactDOM.createPortal(child, container)`
    end

    def find_dom_node(native_react_component)
      `Opal.global.ReactDOM.findDomNode(native_react_component)`
    end

    def hydrate(native_react_element, container, &block)
      # container is a native DOM element
      `Opal.React.render_buffer.push([]);`
      result = if block_given?
                 `Opal.global.ReactDOM.hydrate(native_react_element, container, function() { block.$call() })`
               else
                 `Opal.global.ReactDOM.hydrate(native_react_element, container)`
               end
      `Opal.React.render_buffer.pop()`
      result
    end

    def render(native_react_element, container, &block)
      # container is a native DOM element
      `Opal.React.render_buffer.push([]);`
      result = if block_given?
                 `Opal.global.ReactDOM.render(native_react_element, container, function() { block.$call() })`
               else
                 `Opal.global.ReactDOM.render(native_react_element, container)`
               end
      `Opal.React.render_buffer.pop()`
      result
    end

    def unmount_component_at_node(container)
      # container is a native DOM element
      `Opal.global.ReactDOM.unmountComponentAtNode(container)`
    end
  end
end