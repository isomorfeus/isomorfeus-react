### LucidApp, LucidRouter and LucidComponent
A LucidComponent works very similar like a React::ReduxComponent, the same `store`, `class_store` and `app_store` is available.
The difference is, that the data changes are passed using props instead of setting component state.
Therefore a LucidComponent needs a LucidApp as outer component.
LucidApp sets up a React::Context Provider, LucidComponent works as a React::Context Consumer.
LucidRouter wraps ReactRouter as a convenience to provide routing in the browser as well for server side rendering.
```ruby
class MyApp < LucidApp::Base # is a React::Context provider
  render do
    LucidRouter do
      Switch do
        Route(path: '/', exact: true, component: MyComponent.JS[:react_component])
      end
    end
  end
end

class MyComponent < LucidComponent::Base # is a React::Context Consumer
  store.a_var = 100 # set a initial value for the instance
  class_store.another_var = 200 # set a initial value for the class
  render do
    # in a LucidComponent state can be used for local state managed by react:
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

The lifecycle callbacks starting with `unsafe_` are not supported.
Overwriting should_component_update is also not supported.

**Data flow of a LucidComponent within a LucidApp:**
![LucidComponent within a LucidApp Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_lucid_component.png)
