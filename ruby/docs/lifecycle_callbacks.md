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
Callback names prefixed with UNSAFE_ in React are prefixed with unsafe_ in ruby.
The unsafe callbacks are not available by default and must be required and included.

in the isomorfeus_loader:
```ruby
require 'react/component/unsafe_api'
```

In the component:
```ruby
class MyComponent < React::Component::Base
  include React::Component::UnsafeAPI
```