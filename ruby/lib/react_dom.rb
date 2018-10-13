module ReactDOM
  def create_portal

  end

  def find_dom_node

  end

  def hydrate

  end

  def self.render(native_element, container, &block)
    `Opal.React.render_buffer.push([]);`

    result = if block_given?
               `ReactDOM.render(native_element, container, function() { block.$call() })`
             else
               `ReactDOM.render(native_element, container)`
             end

    `Opal.React.render_buffer.pop([])`

    result
  end

  def unmount_component_at_node

  end
end