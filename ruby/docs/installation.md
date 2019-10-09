## Installation
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
gem 'opal-webpack-loader', '~> 0.9.6'
gem 'opal-autoloader', '~> 0.1.0'
gem 'isomorfeus-redux', '~> 4.0.11'
```
Required Javascript Npms:
- opal-webpack-laoder
- react
- react-dom
- react-router
- react-router-dom
- redux
- react-jss

For the optional MaterialUI support:
- @material-ui/core
- @material-ui/styles

for package.json:
```json
    "opal-webpack-loader": "^0.9.6",
    "react": "^16.10.2",
    "react-dom": "^16.10.2",
    "react-jss": "^10.0.0",
    "react-router": "^5.1.1",
    "react-router-dom": "^5.1.1",
    "redux": "^4.0.1",
```
for the optional MaterialUI support:
```json
    "@material-ui/core": "^4.5.0",
    "@material-ui/styles": "^4.5.0",
```

Then the usual:
- `yarn install`
- `bundle install`

### In the Application
React, Redux and accompanying libraries must be imported and made available in the global namespace in the application javascript entry file,
with webpack this can be ensured by assigning them to the global namespace:
```javascript
import * as Redux from 'redux';
import React from 'react';
import ReactDOM from 'react-dom';
import * as ReactJSS from 'react-jss';
global.Redux = Redux;
global.React = React;
global.ReactDOM = ReactDOM;
global.ReactJSS = ReactJSS;

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
