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
yarn add react@16.8.6
```
then add to the Gemfile:
```ruby
gem 'isomorfeus-react' # this will also include isomorfeus-redux 
```
then `bundle install`

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
Required Javascript Npms:
- opal-webpack-laoder
- react
- react-dom
- react-router
- react-router-dom
- redux

For the optional MaterialUI support:
- @material-ui/core
- @material-ui/styles

for package.json:
```json
    "opal-webpack-loader": "^0.9.1",
    "react": "^16.8.6",
    "react-dom": "^16.8.6",
    "react-router": "^5.0.1",
    "react-router-dom": "^5.0.1",
    "redux": "^4.0.1",
```
for the optional MaterialUI support:
```json
    "@material-ui/core": "^4.0.2",
    "@material-ui/styles": "^4.0.2",
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
global.Router = BrowserRouter; // import and assign StaticRouter instead for Server Side Rendering
global.Link = Link;
global.NavLink = NavLink;
global.Route = Route;
global.Switch = Switch;
```
for the optional MaterialUI support:
```javascript
import * as Mui from '@material-ui/core'
import * as MuiStyles from '@material-ui/styles'
global.Mui = Mui;
global.MuiStyles = MuiStyles;
```

Loading the opal code:
```ruby
require 'opal'
require 'opal-autoloader'
require 'isomorfeus-redux'
require 'isomorfeus-react'
require 'isomorfeus-react-material-ui' # optional, for MaterialUI support
```
## Documentation
Component Types:
- [Class Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/class_component.md)
- [Pure Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/pure_component.md)
- [Function and Memo Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/function_component.md)
- [Redux Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/redux_component.md)
- [Lucid App, Lucid Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/lucid_component.md)
- [LucidMaterial App, LucidMaterial Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/lucid_material_component.md) - support for [MaterialUI](https://material-ui.com)
- [React Javascript Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/javascript_component.md)

Which component to use?
- Usually LucidApp and LucidComponent along with some imported javascript components.

Specific to Class, Pure, Redux, Lucid and LucidMaterial Components:
- [Events](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/events.md)
- [Lifecycle Callbacks](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/lifecycle_callbacks.md)
- [Props](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/props.md)
- [State](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/state.md)

For all Components:
- [Accessibility](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/accessibility.md)
- [Render Blocks](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/render_blocks.md)
- [Rendering HTML or SVG Elements](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/rendering_elements.md)

Special React Features:
- [Context](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/context.md)
- [Fragments](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/fragments.md)
- [Portals](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/portals.md)
- [Refs](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/refs.md)
- [StrictMode](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/strict_mode.md)

Other Features:
- [Code Splitting and Lazy Loading](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/code_splitting_lazy_loading.md)
- [Hot Module Reloading](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/hot_module_relaoding.md)
- [Server Side Rendering](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/server_side_rendering.md)
- [Using React Router](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/react_router.md)
- [Isomorfeus Helpers](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/isomorfeus_helpers.md)

### Development Tools
The React Developer Tools allow for analyzing, debugging and profiling components. A very helpful toolset and working very nice with isomorfeus-react:
https://github.com/facebook/react-devtools

### Specs and Benchmarks
- clone repo
- `bundle install`
- `rake`