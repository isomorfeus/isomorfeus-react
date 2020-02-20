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
gem 'opal-webpack-loader', '~> 0.9.10'
gem 'isomorfeus-react', '>= 16.12.0'
```

Required Javascript Npms:

When using React:
- react
- react-dom

For package.json:
```json
    "react": "^16.12.0",
    "react-dom": "^16.12.0",
```

When using Preact:
- preact
- preact-render-to-string

For package.json:
```json
    "preact": "^10.3.2",
    "preact-render-to-string": "^5.1.4",
```

When using Nervjs:
```json
    "nerv-devtools": "^1.5.6",
    "nerv-server": "^1.5.6",
    "nervjs": "^1.5.6",
```

And these are required:
- opal-webpack-laoder
- react-router
- react-router-dom
- redux

For LucidComponent styling support, required when using LucidComponents:
- react-jss

For the optional MaterialUI support:
- @material-ui/core
- @material-ui/styles

For package.json:
```json
    "opal-webpack-loader": "^0.9.9",
    "react": "^16.12.0",
    "react-dom": "^16.12.0",
    "react-jss": "^10.0.0",
    "react-router": "^5.1.1",
    "react-router-dom": "^5.1.1",
    "redux": "^4.0.1",
```

For the optional MaterialUI support:
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

For the optional MaterialUI support:
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

### Configuration

#### Preact
Things to change when switching from the default React configuration to Preact

##### Webpack
React is resolved with Preact in the webpack configs resolvers:
```javascript
    resolve: {
        alias: {
            "react": "preact/compat",
            "react-dom": "preact/compat"
        }
    }
```

##### Server Side Rendering
The javascript must be directed to the correct renderer in the applications SSR imports:
```javascript
import render from 'preact-render-to-string';
const ReactDOMServer = { renderToString: render };
global.ReactDOMServer = ReactDOMServer;
```

##### Devtools Support
To support React Devtools add this to the applications imports:
```javascript
if (process.env.NODE_ENV==='development') {
    // Must use require here as import statements are only allowed
    // to exist at the top of a file.
    require("preact/debug");
}
```

#### Nervjs

##### Webpack
React is resolved with Nervjs in the webpack configs resolvers:
```javascript
    resolve: {
        alias: {
            'react': 'nervjs',
            'react-dom': 'nervjs',
            'react-dom/server': 'nerv-server'
        }
    }
```

##### Fix for Nervjs with styled components
In javascript imports, after importing React add this line:
```javascript
// Fix for nervjs 1.5.1
global.React.useDebugValue = function(val) { return; };
```

##### Server Side Rendering
Currently doesn't work. `renderToString` from nerv-server v 1.4.6 unfortunately returns just `null`.
If SSR is needed, for the moment use React or Preact.

##### Devtools Support
To support React Devtools add this to the applications imports:
```javascript
if (process.env.NODE_ENV==='development') {
    // Must use require here as import statements are only allowed
    // to exist at the top of a file.
    require('nerv-devtools');
}
```
