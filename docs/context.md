### Context
A context can be created using `React.create_context(constant_name, default_value)`. Constant_name must be a string like `"MyContext"`.
The context withs its Provider and Consumer can then be used like a component:
```ruby
React.create_context("MyContext", 'div')

class MyComponent < React::Component::Base
  render do
    MyContext.Provider(value="span") do
      MyOtherComponent()
    end
  end
end
```
or the consumer:
```ruby
class MyOtherComponent < React::Component::Base
  render do
    MyContext.Consumer do |value|
      Sem.Button(as: value) { 'useful text' }
    end
  end
end
```
