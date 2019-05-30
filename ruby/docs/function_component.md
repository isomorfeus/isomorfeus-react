### Function Components
Function Components are created using a Ruby DSL that is used within the creator class. To create a function component that renders only
when props change, use the memo_component, which uses React.memo:
```ruby
class React::FunctionComponent::Creator
  function_component 'MyComponent' do |props|
    SPAN { props.text }
  end
  # Javascript .-notation can be used for the component name:
  function_component 'MyObject.MyComponent' do |props|
    SPAN { props.text }
  end
  # a React.memo function component:
  memo_component 'MyObject.MyComponent' do |props|
    SPAN { props.text }
  end
end
```
This creates a native javascript components. 
The file containing the creator must be explicitly required, because the automatic resolution of Javascript constant names
is not done by opal-autoloader.

A custom memo props function can be utilized when using React.memo directly with a function component and a block for checking the props:
```ruby
React.memo(`MyComponent`) do |prev_props, next_props|
  prev_props.var != next_props.var
end
```

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
