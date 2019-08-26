### LucidApp and LucidComponent
A LucidComponent works very similar like a React::ReduxComponent, the same `store`, `class_store` and `app_store` is available.
The difference is, that the data changes are passed using props instead of setting component state.
Therefore a LucidComponent needs a LucidApp as outer component.
LucidApp sets up a React::Context Provider, LucidComponent works as a React::Context Consumer.

```ruby
class MyComponent < LucidComponent::Base # is a React::Context Consumer
  store.a_var = 100 # set a initial value for the instance
  class_store.another_var = 200 # set a initial value for the class
  
  # styles can be set using a block that returns a hash, the theme gets passed to the block as hash:
  styles do 
    {
      root: {
        width: 200,
        height: 100
      }
    } 
  end
  
  # or styles can be set using a hash:
  styles(root: { width: 100, height: 100 })

  # a component may refer to some other components styles, if those are given as hash.
  # If the other components styles are given as block, that wont work.
  styles(OtherComponent.styles.deep_merge({ root: {width: 100 }}))
  styles do
    OtherComponent.styles
  end

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

Styles support requires react-jss ^10.0.0, it must be imported like this:
```javascript
import * as ReactJSS from 'react-jss';
global.ReactJSS = ReactJSS;
```

The lifecycle callbacks starting with `unsafe_` are not supported.
Overwriting should_component_update is also not supported.

**Data flow of a LucidComponent within a LucidApp:**
![LucidComponent within a LucidApp Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_lucid_component.png)
