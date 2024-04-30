// entry file for the browser environment
// import stylesheets here
var start = new Date();
import '../styles/application.css';

// import npm modules that are valid to use only in the browser
import ReactDOM from 'react-dom';
globalThis.ReactDOM = ReactDOM;
import { BrowserRouter, Link, NavLink, Route, Switch } from 'react-router-dom';
// global.History = History;
globalThis.Router = BrowserRouter;
globalThis.Link = Link;
globalThis.NavLink = NavLink;
globalThis.Route = Route;
globalThis.Switch = Switch;
// import modules common to browser and server side rendering (ssr)
// environments from application_common.js
import './application_common.js';

