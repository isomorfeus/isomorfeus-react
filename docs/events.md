### Events
Event names are underscored in ruby: `onClick` becomes `on_click`. The conversion for React is done automatically.

Event can be simple methods, but must be referenced when passed as prop by `method_ref`. This is to make sure,
that they are passed by reference during render to react to prevent unnecessary renders. Example:
```ruby
class MyComponent < React::Component::Base
  def handle_click(event, info)
    state.toggler = !state.toggler
  end

  render do
    SPAN(on_click: method_ref(:handle_click)) { 'some more text' }
    SPAN(on_click: method_ref(:handle_click)) { 'a lot more text' } # event handlers can be reused
  end
end
```
Some events pass a optional 'info' arg.

With method_ref additional args can be passed to the event handler:
```ruby
class MyComponent < React::Component::Base
  def handle_click(event, info, arg)
    puts "#{arg}"
  end

  render do
    DIV(on_click: method_ref(:my_handler, "first DIV")) { 'ouch' }
    DIV(on_click: method_ref(:my_handler, "second DIV")) { 'nice' }
  end
end
```
Multiple args can be passed and are appended in order.

To the event handler the event is passed as argument. The event is a ruby object `React::SyntheticEvent` and supports all the methods, properties
and events as the React.Synthetic event. Methods are underscored. Example:
```ruby
class MyComponent < React::Component::Base
  def handle_click(event, info)
    event.prevent_default
    event.current_target
  end

  render do
    SPAN(on_click: method_ref(:handle_click)) { 'some more text' }
  end
end
```
Targets of the event, like current_target, are wrapped Elements as supplied by opal-browser.
Some events pass a optional 'info' arg.
