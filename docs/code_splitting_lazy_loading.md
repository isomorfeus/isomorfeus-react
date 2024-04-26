### Code Splitting with Suspense

React.lazy is available and so is the Suspense Component, in a render block:
```ruby
render do
  Suspense do
    MyComponent()
  end
end
```