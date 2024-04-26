### Lifecycle Callbacks

All lifecycle callbacks that are available in the matching React version are available as DSL. Callback names are underscored.

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

#### Unsafe callbacks

The unsafe callbacks are not available.
