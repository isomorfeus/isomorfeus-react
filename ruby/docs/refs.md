### Refs
Refs must be declared using the `ref` DSL. This is to make sure, that they are not recreated during render and can be properly
compared by reference by shouldComponentUpdate(). Use the DSL like so:
```ruby
class MyComponent < React::Component::Base
  ref :my_ref # a simple ref
  ref :my_other_ref do |ref|  # a ref with block
    ref.current
  end
  
  render do
    SPAN(ref: :my_ref) { 'useful text' } # refs can then be passed as prop
  end
end
```
If the ref declaration supplies a block, the block receives a `React::Ref` ruby instance as argument. `ref.current`may then be the ruby component or
native DOM node. ()The latter may change to something conveniently provided by opal-browser.)
