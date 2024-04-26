## Installation
### Dependencies

Required Javascript Npms:
- react
- react-dom
- react-router
- react-router-dom

For package.json:
```json
    "react": "^17.0.2",
    "react-dom": "^17.0.2",
    "react-router": "^5.2.0",
    "react-router-dom": "^5.2.0",
```

### Importing Javascript Dependencies
React and accompanying libraries must be imported and made available in the global namespace in the application javascript entry file,
with webpack this can be ensured by assigning them to the global namespace:
```javascript
import React from 'react';
import ReactDOM from 'react-dom';
global.React = React;
global.ReactDOM = ReactDOM;

// for routing support
import { BrowserRouter, Link, NavLink, Redirect, Route, Switch } from 'react-router-dom';
global.Router = BrowserRouter; // import and assign StaticRouter instead for Server Side Rendering
global.Link = Link;
global.NavLink = NavLink;
global.Redirect = Redirect;
global.Route = Route;
global.Switch = Switch;
```
