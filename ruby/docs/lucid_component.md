### LucidApp and LucidComponent
The data changes are passed using props instead of setting component state.
Therefore a LucidComponent needs a LucidApp as outer component.
LucidApp sets up a React::Context Provider, LucidComponent works as a React::Context Consumer.
LucidApp also sets up theming.

```ruby
class MyComponent < LucidApp::Base # is a React::Context Consumer
  store.a_var = 100 # set a initial value for the instance
  class_store.another_var = 200 # set a initial value for the class

  # LucidApp can provide a styles theme, it can be referred to by the LucidComponent styles DSL, see below
  theme do
    { master: { width: 200 }}
  end

  # styles can be set using a block that returns a hash, the theme gets passed to the block as hash:
  styles do 
    { root: {
        width: 200,
        height: 100
    }} 
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
    # during render styles can be accessed with `styles`.
    DIV(class_name: styles.root) { 'Some text' }
  end
end
```

```ruby
class MyComponent < LucidComponent::Base # is a React::Context Consumer
  store.a_var = 100 # set a initial value for the instance
  class_store.another_var = 200 # set a initial value for the class
  
  # styles can be set using a block that returns a hash, the theme gets passed to the block:
  styles do |theme|
    {
      root: {
        width: theme.master.width, # access the theme provided by LucidApp
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
    # during render styles can be accessed with `styles`:
    DIV(class_name: styles.root) { 'Some text' }
    # theme value from LucidMaterial::App can be accessed directly too:
    DIV(styles: { width: theme.master.width }.to_n) { 'Some text' }
    # note the .to_n, the styles property requires a native object
  end
end
```

Components that dont need to access the store, because they get all data passed via props for example, can opt out of store updates.
This can improve overall render performance:
```ruby
class MyComponent < LucidComponent::Base
  store_updates :off
  
  render do
    DIV app_store.some_text # store access is still possible,
    # but when app_store.some_text get changed, the component will not render
    
    DIV props.some_text # data changes that require a render must then be passed in props.
    # This is useful for table rows for example or other props that get all data in props. 
  end
end
```
The lifecycle callbacks starting with `unsafe_` are not supported.
Overwriting should_component_update is also not supported.

Data or anything else can be preloaded before rendering
```ruby
class MyComponent < LucidComponent::Base
  # use preload to define what needs to be loaded. The block result must be a promise.
  preload do
    MyGraph.promise_load
  end

  # the block passed to while_loading wil be rendered until the data is loaded
  # and the promise is resolved
  while_loading do
    DIV "Loading data ... Please wait ..."
  end

  # the usual render block is shown when the data has been loaded
  render do
    MyGraph.all_nodes.each do |node|
      DIV node.name
    end
  end
end
```

**Data flow of a LucidComponent within a LucidApp:**
![LucidComponent within a LucidApp Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_lucid_component.png)
