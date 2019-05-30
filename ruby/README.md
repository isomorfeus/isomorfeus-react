# isomorfeus-react

Develop React components for Opal Ruby along with very easy to use and advanced React-Redux Components.

### Community and Support
At the [Isomorfeus Framework Project](http://isomorfeus.com) 

## Versioning
isomorfeus-react version follows the React version which features and API it implements.
Isomorfeus-react 16.5.x implements features and the API of React 16.6 and should be used with React 16.6

## Installation
To install React with the matching version:
```
yarn add react@16.6
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

### Dependencies

For full functionality the following are required:
Ruby Gems:
- [Opal with ES6 modules](https://github.com/opal/opal/pull/1976)
- [Opal Webpack Loader](https://github.com/isomorfeus/opal-webpack-loader)
- [Opal Autoloader](https://github.com/janbiedermann/opal-autoloader)
- [Isomorfeus-Speednode](https://github.com/isomorfeus/isomorfeus-speednode)
- [Isomorfeus-Redux](https://github.com/isomorfeus/isomorfeus-redux)

For the Gemfile:
```ruby
gem 'opal', github: 'janbiedermann/opal', branch: 'es6_modules_1_1'
gem 'opal-webpack-loader', '~> 0.8.4'
gem 'opal-autoloader', '~> 0.0.3'
gem 'isomorfeus-redux', '~> 4.0.4'
gem 'isomorfeus-speednode', '~> 0.2.3'
```
Javascript Npms:
- opal-webpack-laoder
- react
- react-router
- redux

for package.json:
```json
    "opal-webpack-loader": "^0.8.4",
    "react": "16.8",
    "react-dom": "16.8",
    "react-router": "5.0.0",
    "react-router-dom": "5.0.0",
    "redux": "^4.0.1"
```
## Usage
Because isomorfeus-react follows closely the React principles/implementation/API and Documentation, most things of the official React documentation
apply, but in the Ruby way, see:
- https://reactjs.org/docs/getting-started.html

React, Redux and accompanying libraries must be imported and made available in the global namespace in the application javascript entry file,
with webpack this can be ensured by assigning them to the global namespace:
```javascript
import * as Redux from 'redux';
import React from 'react';
import ReactDOM from 'react-dom';
global.Redux = Redux;
global.React = React;
global.ReactDOM = ReactDOM;

// for routing support
import { BrowserRouter, Link, NavLink, Route, Switch } from 'react-router-dom';
global.BrowserRouter = BrowserRouter;
global.Link = Link;
global.NavLink = NavLink;
global.Route = Route;
global.Switch = Switch;
```

Following features are presented with its differences to the Javascript React implementation, along with enhancements and the advanced components.

### Component Types
- [Class Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/class_component.md)
- [Pure Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/pure_component.md)
- [Function Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/function_component.md)
- [Redux Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/redux_component.md)
- [Lucid App, Lucid Router and Lucid Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/lucid_component.md)
- [React Javascript Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/javascript_component.md)

Which component to use?
- Usually LucidApp, LucidRouter and LucidComponent along with some javascript components.
- For improved performance small Function Components may help at critical spots.

### Props
[Props](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/props.md)

### State
[State](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/state.md)

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

#### Events and Function Components
The event_handler DSL can be used within the React::FunctionComponent::Creator. However, function component dont react by themselves to events,
the event handler must be applied to a element.
```ruby
class React::FunctionComponent::Creator
  event_handler :show_red_alert do |event|
    `alert("RED ALERT!")`
  end

  event_handler :show_orange_alert do |event|
    `alert("ORANGE ALERT!")`
  end

  function_component 'AFunComponent' do
    SPAN(on_click: props.on_click) { 'Click for orange alert! ' } # event handler passed in props, applied to a element
    SPAN(on_click: :show_red_alert) { 'Click for red alert! '  } # event handler directly applied to a element
  end

  function_component 'AnotherFunComponent' do
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

### Code Splitting with Suspense (doc is wip)

React.lazy is availalable and so is the Suspense Component, in a render block:
```ruby
render do
  Suspense do
    MyComponent()
  end
end
```
### Development Tools
The React Developer Tools allow for analyzing, debugging and profiling components. A very helpful toolset and working very nice with isomorfeus-react:
https://github.com/facebook/react-devtools

### Execution Environment
Code can run in 3 different environments:
- On the Browser, for normal execution
- On nodejs, for server side rendering
- On the server, for normal execution of server side code

The following helpers are available to determine the execution environment:
- `Isomorfeus.on_browser?` - true if running on the browser, otherwise false
- `Isomorfeus.on_ssr?` - true if running on node for server side rendering, otherwise false
- `Isomorfeus.on_server?` - true if running on the server, otherwise false

### Server Side Rendering
SSR is turned on by default in production and turned of in development. SSR is done in node using isomorfeus-speednode.
Components that depend on a browser can be shielded from rendering in node by using the above execution environment helper methods.
Example:
```ruby
class MyOtherComponent < React::Component::Base

  render do
    if Isomorfeus.on_browser?
      SomeComponentDependingOnWindow()
    else
      DIV()
    end
  end
end
```

### Hot Module Reloading

HMR is supported when using LucidApp as top level component.
A render after a code update can be triggered using:
```ruby
Isomorfeus.force_render
```
