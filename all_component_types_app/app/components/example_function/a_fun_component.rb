module ExampleFunction
  class AFunComponent < React::FunctionComponent::Base
    render do
      SPAN(on_click: props.on_click) { 'Click for orange alert! Props: ' }
      SPAN { props.text }
      SPAN { ', Children: '  }
      SPAN { props.children }
      SPAN { ' ' }
      SPAN { '| '}
    end
  end
end
