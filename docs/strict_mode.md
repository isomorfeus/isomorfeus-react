### StrictMode
React.StrictMode can be used like so:
```ruby
class MyComponent < React::Component::Base
  render do
    StrictMode do
      SPAN { 'useful text' }
    end
  end
end
```
