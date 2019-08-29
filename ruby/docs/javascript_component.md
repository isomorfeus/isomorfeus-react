### React Javascript Components

Native React Javascript Components must be available in the global namespace. When importing them with webpack
this can be ensured by assigning them to the global namespace:
```javascript
import * as Sem from 'semantic-ui-react'
global.Sem = Sem;
```
They can then be used like so:
```ruby
class MyComponent < React::Component::Base
  render do
    Sem.Button(as: 'a') { 'useful text' }
  end
end
```

Some Javascript components accept another Javascript component as property, like for example React Router. The Ruby class won't work here,
instead the Javascript React component of the Ruby class must be passed.
It can be accessed by using Opals JS syntax to get the React Component of the Ruby class:
```ruby
Route(path: '/', strict: true, component: MyComponent.JS[:react_component])
```

Native Javascript components can be passed using the Javascript inlining of Opal, this also works for function components.
But for Server Side Rendering there is no global `window` Object to which all javascript constants get added, instead the global context must
be explicitly referred to:
```ruby
Route(path: '/a_button', strict: true, component: `Opal.global.Sem.Button`)
```
Accessing javascript constants via `Opal.global` makes sure they are available in the Browser and Server Side Rendering environment.

### Passing React Elements of Ruby Components via property

Some Javascript components accept a React Element as property. A React Element can very naturally be passed in the render block just by using
components in place:
```ruby
Mui.Tab(label: Mui.Hidden(smDown: true) { 'Timeline' })
```
Mui.Tab, which accepts a property `label` with a React Element, `Mui.Hidden(smDown: true) { 'Timeline' }` just provides that.
However, within a render block assigning a React Element by just rendering a Component to a variable and reusing it later on is not supported and does NOT work as expected:
```ruby
class NotWorking < React::Component::Base
  render do
    el = Mui.Hidden(smDown: true) { 'Timeline' }
    DIV "NOT WORKING"
    Mui.Tab(label: el)
  end
end
```
