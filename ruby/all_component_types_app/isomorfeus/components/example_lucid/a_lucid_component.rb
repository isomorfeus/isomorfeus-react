module ExampleLucid
  class ALucidComponent < LucidComponent::Base
    prop :text, default: 'prop not passed'

    state.some_bool = true

    store.a_bool = true
    class_store.b_bool = true
    app_store.c_bool = true

    event_handler :change_state do |event|
      state.some_bool = !state.some_bool
    end

    event_handler :change_store do |event|
      store.a_bool = !store.a_bool
    end

    event_handler :change_class_store do |event|
      class_store.b_bool = !class_store.b_bool
    end

    event_handler :change_app_store do |event|
      app_store.c_bool = !app_store.c_bool
    end

    render do
      SPAN(on_click: props.on_click) { 'Click for orange alert! Props: ' }
      SPAN { props.text }
      SPAN(on_click: :change_state) { ", state is: #{state.some_bool} (Click!)" }
      SPAN(on_click: :change_store) { ", store is: #{store.a_bool} (Click!)" }
      SPAN(on_click: :change_class_store) { ", class_store is: #{class_store.b_bool} (Click!)" }
      SPAN(on_click: :change_app_store) { ", app_store is: #{app_store.c_bool} (Click!)" }
      SPAN { ', Children: '  }
      SPAN { props.children }
      SPAN { '| '}
    end
  end
end