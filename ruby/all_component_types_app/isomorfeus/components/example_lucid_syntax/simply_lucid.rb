module ExampleLucidSyntax
  class SimplyLucid < LucidComponent::Base
    prop :letter, default: 'prop not passed'

    app_store.letter = 'A'

    event_handler :change_letter do |event|
      letter = app_store.letter
      code = `letter.charCodeAt(0)`
      code = code + 1
      code = 65 if code > 90
      app_store.letter = `String.fromCharCode(code)`
    end

    render do
      SPAN({ on_click: :change_letter }, app_store.letter + props.letter + ' ')
    end
  end
end