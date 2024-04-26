### Portals
Portals can be created like so:
```ruby
class MyComponent < React::Component::Base
  render do
    Portal(`document.querySelector('div')`) do
      SPAN { 'useful text' }
    end
  end
end
```
Portals also accept a simple css query string:
```ruby
class MyComponent < React::Component::Base
  render do
    Portal('#some_id') do
      SPAN { 'useful text' }
    end
  end
end
```