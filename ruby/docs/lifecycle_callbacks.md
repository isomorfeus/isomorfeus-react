### Lifecycle Callbacks

All lifecycle callbacks that are available in the matching React version are available as DSL. Callback names are underscored.
Callback names prefixed with UNSAFE_ in React are prefixed with unsafe_ in ruby.
Example:
```ruby
class MyComponent < React::Component::Base
  render do
    SPAN { 'some more text' }
  end

  component_did_mount do
    `console.log("MyComponent mounted!")`
  end
end
```
