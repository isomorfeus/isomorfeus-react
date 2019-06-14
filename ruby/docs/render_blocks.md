### Render blocks
render or element or component blocks work like ruby blocks, the result of the last expression in a block is returned and then rendered,
but only if it is a string or a React Element.
HTML Elements and Components at any place in the blocks are rendered too.
Examples:
```ruby
class MyComponent < React::Component::Base
  render do
    SPAN { "string" } # this string is rendered in a SPAN HTML Element
    SPAN { "another string" } # this string is rendered in a SPAN too
  end
end
```
```ruby
class MyComponent < React::Component::Base
  render do
    "string" # this string is NOT rendered, its not returned from the block and its not wrapped in a Element,
             # to render it, wrap it in a element or fragment
    "another string" # this string is returned from the block, so its rendered
  end
end
```
```ruby
class MyComponent < React::Component::Base
  render do
    Fragment { "string" } # this string is rendered without surrounding element
    100 # this is not a string, so its NOT rendered, to render it, simply convert it to a string: "#{100}" or 100.to_s
  end
end
```
There is a shorthand "string param syntax". Its advantages are:
- reduced asset size, because it reduces the amount of compiled blocks, strings are passed as param instead
- improved performance, because it reduces the amount of executed blocks, strings are passed as param instead

Its disadvantages are:
- it looks a bit odd when other params are passed

The first render block example in "string param syntax":
```ruby
class MyComponent < React::Component::Base
  render do
    SPAN "string" # this string is rendered in a SPAN HTML Element, short and handy
    SPAN "another string" # this string is rendered in a SPAN too, short and handy
    
    # "string param syntax" with additional params:
    SPAN({class: 'design'}, "yet another string") # <- not recommended
    # for comparison the "string block syntax" with additonal params
    SPAN(class: 'design') { 'even a string' }     # <- recommended, looks better
  end
end
```

Also &nbsp\; doesn't work in strings, instead "\u00A0" must be used.
