### React::ReduxComponent
This component is like a React::Component and in addition to it, allows do manage its state conveniently over redux using a simple DSL:
- `store` - works similar like the components state, but manages the components state with redux
- `class_store` - allows to have a class state, when changing this state, all instances of the component class change the state and render
- `app_store` - allows to access application state, when changing this state, all instances that have requested the same variables, will render.
```ruby
class MyComponent < React::PureComponent::Base
  store.a_var = 100 # set a initial value for the instance
  class_store.another_var = 200 # set a initial value for the class
  app_store.yet_another_var = 300
  
  event_handler :clicky do
    # To make component 'pure' as much as possible, it is recommended to set or change values in any of the stores
    # only outside of render, for example in a event_handler
    # in a React::ReduxComponent state can be used for local state managed by react:
    state.some_var = 10
    # in addition to that, store can be used for local state managed by redux:
    store.a_var = 200
    # and for managing class state:
    class_store.another_var = 300
    # and for managing application wide state:
    app_store.yet_another_var = 4000
  end
  
  render do
    DIV(on_click: :clicky) do
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
end
```
Using the ReduxDevTools for chrome or firefox, state changes using `store`, `class_store` or `app_store` can be watched, recorded, replayed,
debugged and otherwise.

The lifecycle callbacks starting with `unsafe_` are not supported.
Overwriting should_component_update is also not supported.

**Data flow of a React::ReduxComponent:**
![React::ReduxComponent Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_redux_component.png)
