### Class Components
Class Components can be created in two ways, either by inheritance or by including a module.
Inheritance:
```ruby
class MyComponent < React::Component::Base

end
```
including a module:
```ruby
class MyComponent
  include React::Component::Mixin

end
```

Each Component must have at least a render block:
```ruby
class MyComponent < React::Component::Base
  render do
    DIV { "some text" }
  end
end
```

Class Component allow for the definition of a custom should_component_update? block, but that is optional:
```ruby
class MyComponent < React::Component::Base
  should_component_update? do |next_props, next_state|
    return true # to always update for example
  end
  
  render do
    DIV { "some text" }
  end
end
```
A default should_component_update? implementation is supplied. The default should_component_update? implementation for Class Components is most
efficient if complex props or state are used.

**Data flow of a React::Component:**
![React::Component Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_component.png)

