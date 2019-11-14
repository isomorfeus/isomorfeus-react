module ExampleMaterial
  class AnotherMaterialComponent < LucidMaterial::Component::Base
    styles do
      {
        master: {
          color: 'black'
        }
      }
    end

    event_handler :show_red_alert do |event|
      `alert("RED ALERT!")`
    end

    event_handler :show_orange_alert do |event|
      `alert("ORANGE ALERT!")`
    end

    render do
      AMaterialComponent(on_click: :show_orange_alert, text: 'Yes') do
        SPAN(on_click: :show_red_alert, class_name: styles.root) { 'Click for red alert! (Child 1), ' }
        SPAN { 'Child 2, '}
        SPAN { 'etc. '}
      end
    end
  end
end