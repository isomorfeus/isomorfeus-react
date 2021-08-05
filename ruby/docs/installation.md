## Installation
### Dependencies

For full functionality the following are required:

Ruby Gems:

- [Opal with ES6 modules](https://github.com/opal/opal/pull/1976)
- [Opal Webpack Loader](https://github.com/isomorfeus/opal-webpack-loader)
- [Opal-Zeitwerk Autoloader](https://github.com/isomorfeus/opal-zeitwerk)

For the Gemfile:
```ruby
gem 'opal', github: 'janbiedermann/opal', branch: 'es6_modules_1_1'
gem 'opal-webpack-loader', '~> 0.11.4'
gem 'isomorfeus-react', '>= 17.0.0'
```

Required Javascript Npms:

#### When using React
- react
- react-dom

For package.json:
```json
    "react": "^17.0.2",
    "react-dom": "^17.0.2",
```

#### Common requirements
- opal-webpack-loader
- react-router
- react-router-dom
- redux

For LucidComponent styling support, required when using LucidComponents:
- react-jss

For package.json:
```json
    "opal-webpack-loader": "^0.11.4",
    "react": "^17.0.2",
    "react-dom": "^17.0.2",
    "react-jss": "^10.7.1",
    "react-router": "^5.2.0",
    "react-router-dom": "^5.2.0",
    "redux": "^4.1.0",
```

#### Optional MaterialUI support
- @material-ui/core
- @material-ui/styles

For package.json:
```json
    "@material-ui/core": "^4.12.3",
    "@material-ui/styles": "^4.11.4",
```

Then the usual:
- `yarn install`
- `bundle install`

### Importing Javascript Dependencies
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
import { BrowserRouter, Link, NavLink, Redirect, Route, Switch } from 'react-router-dom';
global.Router = BrowserRouter; // import and assign StaticRouter instead for Server Side Rendering
global.Link = Link;
global.NavLink = NavLink;
global.Redirect = Redirect;
global.Route = Route;
global.Switch = Switch;
```

#### For the optional MaterialUI support:
```javascript
import * as Mui from '@material-ui/core'
import * as MuiStyles from '@material-ui/styles'
global.Mui = Mui;
global.MuiStyles = MuiStyles;
```

Loading the opal code:
```ruby
require 'isomorfeus-react'
require 'isomorfeus-react-material-ui' # optional, for MaterialUI support
```

#### For the optional Paper support:
```javascript
import * as Paper from 'react-native-paper';
global.Paper = Paper;
```

Loading the opal code:
```ruby
require 'isomorfeus-react'
require 'isomorfeus-react-paper' # optional, for Paper support
```

Additional steps are required to configure webpack properly, please see [Using Paper on the Web](https://callstack.github.io/react-native-paper/using-on-the-web.html)
