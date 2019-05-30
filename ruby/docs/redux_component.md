### React::ReduxComponent
This component is like a React::Component and in addition to it, allows do manage its state conveniently over redux using a simple DSL:
- `store` - works similar like the components state, but manages the components state with redux
- `class_store` - allows to have a class state, when changing this state, all instances of the component class change the state and render
- `app_store` - allows to access application state, when changing this state, all instances that have requested the same variables, will render.
```ruby
class MyComponent < React::PureComponent::Base
  store.a_var = 100 # set a initial value for the instance
  class_store.another_var = 200 # set a initial value for the class
  render do
    # in a React::ReduxComponent state can be used for local state managed by react:
    state.some_var
    # in addition to that, store can be used for local state managed by redux:
    store.a_var
    # and for managing class state:
    class_store.another_var
    # and for managing application wide state:
    app_store.yet_another_var
  end
end
```
Provided some middleware is used for redux, state changes using `store` or `class_store` can be watched, debugged and otherwise handled by redux
middleware.

The lifecycle callbacks starting with `unsafe_` are not supported.
Overwriting should_component_update is also not supported.

**Data flow of a React::ReduxComponent:**
![React::ReduxComponent Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_redux_component.png)
