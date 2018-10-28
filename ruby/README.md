# isomorfeus-react

Develop React components for Opal Ruby along with very easy to use and advanced React-Redux Components.

## Versioning
isomorfeus-react version follows the React version which features and API it implements.
Isomorfeus-react 16.5.x implements features and the API of React 16.5 and should be used with React 16.5

## Installation
To install React with the matching version:
```
yarn add react@16.5
```
then add to the Gemfile:
```ruby
gem 'isomorfeus-react' # this will also include isomorfeus-redux 
```
then `bundle install`
and to your client code add:
```ruby
require 'isomorfeus-react' # this will also require isomorfeus-redux
```
## Usage
Because isomorfeus-react follows closely the React principles/implementation/API and Documentation, most things of the official React documentation
apply, but in the Ruby way, see:
- https://reactjs.org/docs/getting-started.html

Redux is also required, for the more advanced components to function properly.

React, Redux and accompanying libraries must be imported and made available in the global namespace in the application javascript entry file,
with webpack this can be ensured by assigning them to the global namespace:
```javascript
import * as Redux from 'redux';
import React from 'react';
import ReactDOM from 'react-dom';
global.Redux = Redux;
global.React = React;
global.ReactDOM = ReactDOM;
```

Following features are presented with its differences to the Javascript React implementation, along with enhancements and the advanced components.

### Class Components
Class Components can be created in two ways, either by inheritance or by including a module.
Inheritance:
```ruby
class MyComponent < React::Component::Base

end
```
including a module:
```ruby
class MyComponent
  include React::Component::Mixin

end
```

Each Component must have at least a render block:
```ruby
class MyComponent < React::Component::Base
  render do
    DIV { "some text" }
  end
end
```

Class Component allow for the definition of a custom should_component_update? block, but that is optional:
```ruby
class MyComponent < React::Component::Base
  should_component_update? do |next_props, next_state|
    return true # to always update for example
  end
  
  render do
    DIV { "some text" }
  end
end
```
A default should_component_update? implementation is supplied. The default should_component_update? implementation for Class Components is most
efficient if complex props or state are used.

**Data flow of a React::Component:**
![React::Component Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_component.png)


### Pure Components
Pure Components can be created in two ways, either by inheritance or by including a module.
Inheritance:
```ruby
class MyComponent < React::PureComponent::Base

end
```
including a module:
```ruby
class MyComponent
  include React::PureComponent::Mixin

end
```

Each Component must have at least a render block:
```ruby
class MyComponent < React::PureComponent::Base
  render do
    DIV { "some text" }
  end
end
```

A PureComponent does not allow for the definition of a custom should_component_update? block. Its using the default React implementation instead.
Its recommended to use them only if no props or state are used or if props and state have simple values only, like strings or numbers.

**Data flow of a React::PureComponent:**
![React::PureComponent Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_component.png)

### Functional Components
Functional Components are created using a Ruby DSL that is used within the creator class:
```ruby
class React::FunctionalComponent::Creator
  functional_component 'MyComponent' do |props|
    SPAN { props.text }
  end
  # Javascript .-notation can be used for the component name:
  functional_component 'MyObject.MyComponent' do |props|
    SPAN { props.text }
  end
end
```
This creates a native javascript components. 
The file containing the creator must be explicitly required, because the automatic resolution of Javascript constant names
is not done by opal-autoloader.
 
A Functional Component can then be used in other Components:
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

**Data flow of a React::FunctionalComponent:**
![React::FunctionalComponent Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_functional_component.png)

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
  
  render do
    DIV { props.text }
  end
end
```

### State
State can be accessed in components using `state`:
```ruby
class MyComponent < React::PureComponent::Base
  render do
    if state.toggled
      DIV { 'toggled' }
    else
      DIV { 'not toggled' }
    end
  end
end
```
State can be intialized like so:
```ruby
class MyComponent < React::PureComponent::Base
  state.toggled = false
  
  render do
    if state.toggled
      DIV { 'toggled' }
    else
      DIV { 'not toggled' }
    end
  end
end
```
State can be changed like so, the component setState() will be called:
```ruby
class MyComponent < React::PureComponent::Base
  render do
    if some_condition_is_met
      
      state.toggled = true # calls components setState to cause a render
      
      # or if a callback is needed:
      
      set_state({toggled: true}) do
        # some callback code here
      end
    end
    if state.toggled
      DIV { 'toggled' }
    else
      DIV { 'not toggled' }
    end
  end
end
```
When changing state, the state is not immediately available, just like in React! For example:
```ruby
class MyComponent < React::PureComponent::Base
  render do
    previous_state_value = state.variable
    state.variable = next_state_value # even though this looks like a assignment, it causes a side effect
                                      # state may be updated after the next render cycle
    next_state_value == state.variable # very probably false here until next render
    previous_state_value == state.variable # probably true here until next render
    
    # to work with next_state_value, wait for the next render cycle, or just keep using the next_state_value variable here instead of state.value
  end
end
```
To make the side effect of a set_state more visible, state can be set by using a method call instead of a assignment:
```ruby
class MyComponent < React::PureComponent::Base
  render do
    previous_state_value = state.variable
    state.variable(next_state_value) # setting state with a method call, it causes a side effect
                                     # state may be updated after the next render cycle
    next_state_value == state.variable # very probably false here until next render
    previous_state_value == state.variable # probably true here until next render
    
    # to work with next_state_value, wait for the next render cycle, or just keep using the next_state_value variable here instead of state.value
  end
end
```
### Lifecycle Callbacks
All lifecycle callbacks that are available in the matching React version are available as DSL. Callback names are underscored.
Callback names prefixed with UNSAFE_ in React are prefixed with unsafe_ in ruby.
Example:
```ruby
class MyComponent < React::Component::Base
  render do
    SPAN { 'some more text' }
  end

  component_did_mount do
    `console.log("MyComponent mounted!")`
  end
end
```

### Events
Event names are underscored in ruby: `onClick` becomes `on_click`. The conversion for React is done automatically.


Event handlers must be declared using the `event_handler` DSL. This is to make sure, that they are not recreated during render and can be properly
compared by reference by shouldComponentUpdate(). Use the DSL like so:
```ruby
class MyComponent < React::Component::Base
  event_handler :handle_click do |event|
    state.toggler = !state.toggler
  end
  
  render do
    SPAN(on_click: :handle_click) { 'some more text' }
    SPAN(on_click: :handle_click) { 'a lot more text' } # event handlers can be reused
  end
end
```

To the event handler the event is passed as argument. The event is a ruby object `React::SyntheticEvent` and supports all the methods, properties
and events as the React.Synthetic event. Methods are underscored. Example:
```ruby
class MyComponent < React::Component::Base
  event_handler :handle_click do |event|
    event.prevent_default 
    event.current_target
  end
  
  render do
    SPAN(on_click: :handle_click) { 'some more text' }
  end
end
```
Targets of the event, like current_target, are wrapped Elements as supplied by opal-browser.

#### Events and Functional Components
The event_handler DSL can be used within the React::FunctionalComponent::Creator. However, functional component dont react by themselves to events,
the event handler must be applied to a element.
```ruby
class React::FunctionalComponent::Creator
  event_handler :show_red_alert do |event|
    `alert("RED ALERT!")`
  end

  event_handler :show_orange_alert do |event|
    `alert("ORANGE ALERT!")`
  end

  functional_component 'AFunComponent' do
    SPAN(on_click: props.on_click) { 'Click for orange alert! ' } # event handler passed in props, applied to a element
    SPAN(on_click: :show_red_alert) { 'Click for red alert! '  } # event handler directly applied to a element
  end

  functional_component 'AnotherFunComponent' do
    AFunComponent(on_click: :show_orange_alert, text: 'Fun') # event handler passed as prop, but must be applied to element, see above
  end
end
```
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
### Rendering HTML or SVG Elements
Elements are rendered using a DSL which provides all Elements supported by React following these specs:
- https://www.w3.org/TR/html52/fullindex.html#index-elements
- https://www.w3.org/TR/SVG11/eltindex.html

The DSL can be used like so:
```ruby
class MyComponent < React::Component::Base
  render do
    SPAN { 'some more text' } # upper case
    span { 'so much text' } # lower case
  end
end
```
Use whichever you prefer. There are some clashes with opal ruby kernel methods, like `p 'text'`, that may have to be considered.

### Accessibility
Props like `aria-label` must be written underscored `aria_label`. They are automatically converted for React. Example:
```ruby
class MyComponent < React::Component::Base
  render do
    SPAN(aria_label: 'label text') { 'some more text' }
  end
end
```

### Fragments
Fragments can be created like so:
```ruby
class MyComponent < React::Component::Base
  render do
    Fragment do
      SPAN { 'useful text' }
      SPAN { 'extremely useful text' }
    end
  end
end
```

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
Portals currently require a native DOM node as argument. (This may change to something conveniently provided by opal-browser.)

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

### Ref
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

### React Javascript Components
Native React Javascript Components must be available in the global namespace. When importing them with webpack,
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
Native Javascript components can be passed using the Javascript inlining of Opal, this also works for functional components:
```ruby
Route(path: '/a_button', strict: true, component: `Sem.Button`)
```

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

### Using React Router
First the Components of React Router must be imported and made available in the global context:
```javascript
import * as ReactRouter from 'react-router';
import * as ReactRouterDOM from 'react-router-dom';
import { BrowserRouter, Link, NavLink, Route, Switch } from 'react-router-dom';

global.ReactRouter = ReactRouter;
global.ReactRouterDOM = ReactRouterDOM;
global.BrowserRouter = BrowserRouter;
global.Link = Link;
global.NavLink = NavLink;
global.Route = Route;
global.Switch = Switch;
```
Only import whats needed, or import HashRouter instead of BrowserRouter.
Then the Router components can be used as an other component:
```ruby
class RouterComponent < React::Component::Base
  render do
    DIV do
      BrowserRouter do
        Switch do
          Route(path: '/my_path/:id', exact: true, component: MyOtherComponent.JS[:react_component])
          Route(path: '/', strict: true, component: MyCompnent.JS[:react_component])
        end
      end
    end
  end
end
```
The Javascript React components of the ruby class must be passed as shown above. The child components then get the Router props
(match, history, location) passed in their props. They can be accessed like this:
```ruby
class MyOtherComponent < React::Component::Base

  render do
    Sem.Container(text_align: 'left', text: true) do
      DIV do
        SPAN { 'match :id is: ' }
        SPAN { props.match.id }
      end
      DIV do
        SPAN { 'location pathname is: ' }
        SPAN { props.location.pathname }
      end
      DIV do
        SPAN { 'number of history entries: ' }
        SPAN { props.history.length }
      end
    end
  end
end
```
Otherwise the React Router documentation applies: https://reacttraining.com/react-router/

### React::ReduxComponent
This component is like a React::Component and in addition to it, allows do manage its state conveniently over redux using a simple DSL:
- `store` - works similar like the components state, but manages the components state with redux
- `class_store` - allows to have a class state, when changing this state, all instances of the component class change the state and render
- `app_store` - allows to access application state, when changing this state, all instances that have requested the same variables, will render.
```ruby
class MyComponent < React::PureComponent::Base
  store.a_var = 100 # set a initial value for the instance
  class_store.another_var = 200 # set a initial value for the class
  render do
    # in a React::ReduxComponent state can be used for local state managed by react:
    state.some_var
    # in addition to that, store can be used for local state managed by redux:
    store.a_var
    # and for managing class state:
    class_store.another_var
    # and for managing application wide state:
    app_store.yet_another_var
  end
end
```
Provided some middleware is used for redux, state changes using `store` or `class_store` can be watched, debugged and otherwise handled by redux
middleware.

The lifecycle callbacks starting with `unsafe_` are not supported.
Overwriting should_component_update is also not supported.

**Data flow of a React::ReduxComponent:**
![React::ReduxComponent Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_redux_component.png)

### LucidApp and LucidComponent
A LucidComponent works very similar like a React::ReduxComponent, the same `store` and `class_store` is available. The difference is, that the
data changes are passed using props instead of setting component state. Therefore, a LucidComponent needs a LucidApp as outer component.
LucidApp sets up a React::Context Provider, LucidComponent works as a React::Context Consumer.
```ruby
class MyApp < LucidApp::Base # is a React::Context provider
  render do
    MyComponent()
  end
end

class MyComponent < LucidComponent::Base # is a React::Context Consumer
  store.a_var = 100 # set a initial value for the instance
  class_store.another_var = 200 # set a initial value for the class
  render do
    # in a LucidComponent state can be used for local state managed by react:
    state.some_var
    # in addition to that, store can be used for local state managed by redux:
    store.a_var
    # and for managing class state:
    class_store.another_var
    # and for managing application wide state:
    app_store.yet_another_var
  end
end
```

The lifecycle callbacks starting with `unsafe_` are not supported.
Overwriting should_component_update is also not supported.

**Data flow of a LucidComponent within a LucidApp:**
![LucidComponent within a LucidApp Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_lucid_component.png)

### Development Tools
The React Developer Tools allow for analyzing, debugging and profiling components. A very helpful toolset and working very nice with isomorfeus-react:
https://github.com/facebook/react-devtools