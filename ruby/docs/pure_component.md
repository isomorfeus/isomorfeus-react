### Pure Components
Pure Components can be created in two ways, either by inheritance or by including a module.
  Inheritance:
  ```ruby
class MyComponent < React::PureComponent::Base

end
```
including a module:
```ruby
class MyComponent
  include React::PureComponent::Mixin

end
```

Each Component must have at least a render block:
```ruby
class MyComponent < React::PureComponent::Base
  render do
    DIV { "some text" }
  end
end
```

A PureComponent does not allow for the definition of a custom should_component_update? block. Its using the default React implementation instead.
  Its recommended to use them only if no props or state are used or if props and state have simple values only, like strings or numbers.

  **Data flow of a React::PureComponent:**
![React::PureComponent Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_component.png)
