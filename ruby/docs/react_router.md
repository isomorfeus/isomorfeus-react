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
