module ExampleLucidSyntax
  class AnotherLucidComponent < LucidComponent::Base
    event_handler :show_red_alert do |event|
      `alert("RED ALERT!")`
    end

    event_handler :show_orange_alert do |event|
      `alert("ORANGE ALERT!")`
    end

    render do
      ALucidComponent(on_click: :show_orange_alert, text: 'Yes') do
        SPAN({ on_click: :show_red_alert }, 'Click for red alert! (Child 1), ')
        SPAN 'Child 2, '
        SPAN 'etc. '
      end
    end
  end
end