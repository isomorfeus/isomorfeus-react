### Events
Event names are underscored in ruby: `onClick` becomes `on_click`. The conversion for React is done automatically.

Event handlers must be declared using the `event_handler` DSL. This is to make sure, that they are not recreated during render and can be properly
compared by reference by shouldComponentUpdate(). Use the DSL like so:
```ruby
class MyComponent < React::Component::Base
  def handle_click(event)
    state.toggler = !state.toggler
  end
  
  render do
    SPAN(on_click: :handle_click) { 'some more text' }
    SPAN(on_click: :handle_click) { 'a lot more text' } # event handlers can be reused
  end
end
```

To the event handler the event is passed as argument. The event is a ruby object `React::SyntheticEvent` and supports all the methods, properties
and events as the React.Synthetic event. Methods are underscored. Example:
```ruby
class MyComponent < React::Component::Base
  def handle_click(event)
    event.prevent_default 
    event.current_target
  end
  
  render do
    SPAN(on_click: :handle_click) { 'some more text' }
  end
end
```
Targets of the event, like current_target, are wrapped Elements as supplied by opal-browser.
