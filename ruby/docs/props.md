### Props

In ruby props are underscored: `className -> class_name`. The conversion for React is done automatically.
Within a component props can be accessed using `props`:
```ruby
class MyComponent < React::PureComponent::Base
  render do
    DIV { props.text }
  end
end
```
Props are passed as argument to the component:
```ruby
class MyOtherComponent < React::PureComponent::Base
  render do
    MyComponent(text: 'some other text')
  end
end
```
Props can be declared and type checked and a default value can be given:
```ruby
class MyComponent < React::PureComponent::Base
  prop :text, class: String # a required prop of class String, class must match exactly
  prop :other, is_a: Enumerable # a required prop, which can be a Array for example, but at least must be a Enumerable
  prop :cool, default: 'yet some more text' # a optional prop with a default value
  prop :even_cooler, class: String, required: false # a optional prop, which when given, must be of class String
  prop :super # a required prop of any type
  
  render do
    DIV { props.text }
  end
end
```
