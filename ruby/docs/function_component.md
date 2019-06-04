### Function Components
Function Components are created using a Ruby DSL that is used within the creator class. 
```ruby
class MyFunctionComponent < React::FunctionComponent::Base
  create_component do |props|
    SPAN { props.text }
  end
end
```
This creates a native javascript component 'MyFunctionComponent'. 


A Function Component can then be used in other Components:
```ruby
class MyComponent < React::PureComponent::Base
  render do
    MyComponent(text: 'some text')
    MyObject.MyComponent(text: 'more text')
  end
end
```
To get the native component, for example to pass it in props, javascript inlining can be used:
```ruby
Route(path: '/fun_fun/:count', exact: true, component: `MyObject.MyComponent`)
```

**Data flow of a React::FunctionComponent:**
![React::FunctionComponent Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_function_component.png)

#### Memo
To create a function component that renders only when props change, use the memo_component, which uses React.memo:
```ruby
class MyFunctionComponent < React::MemoComponent::Base
  create_component do |props|
    SPAN { props.text }
  end
  
  # A custom memo function can be utilized to check if a render should happen
  # must appear AFTER create component, because it requires the native component to already exist.  
  memo do |prev_props, next_props|
    prev_props != next_props
  end
end
```

A custom memo props function can also be utilized when using React.memo directly with a function component and a block for checking the props:
```ruby
React.memo(`MyComponent`) do |prev_props, next_props|
  prev_props.var != next_props.var
end
```


#### Hooks
##### useState -> use_state
```ruby
class MyFunctionComponent
  include React::FunctionComponent::Base
  
  event_handler :incr_counter do |event|
    set_counter(@counter + 1)
  end
  
  create_component do |props|
    @counter = use_state(:counter, 0)
    
    SPAN(on_click: :incr_counter) { props.text }
  end
end
```
`use_state(name, initial_value)` - creates as setter method for the name given and calls React.useState for setting the initial value.

##### useEffect -> use_effect
```ruby
class MyFunctionComponent
  include React::FunctionComponent::Base
  create_component do |props|
    use_effect do
      # show effect
    end
   
    SPAN { props.text }
  end
end
```

##### useContext -> use_context
```ruby
React.create_context('MyContext', 10)

class MyFunctionComponent
  include React::FunctionComponent::Base
  create_component do |props|
    value = use_context(MyContext) 
   
    SPAN { props.text }
  end
end
```