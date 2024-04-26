### Accessibility
Props like `aria-label` must be written underscored `aria_label`. They are automatically converted for React. Example:
```ruby
class MyComponent < React::Component::Base
  render do
    SPAN(aria_label: 'label text') { 'some more text' }
  end
end
```
