// entry file for the server side rendering environment (ssr)
// import npm modules that are only valid to use in the server side rendering environment
// for example modules which depend on objects provided by node js
import ReactDOMServer from 'react-dom/server';
globalThis.ReactDOMServer = ReactDOMServer;
import { StaticRouter, Link, NavLink, Route, Switch } from 'react-router-dom';
// global.History = History;
globalThis.Router = StaticRouter;
globalThis.Link = Link;
globalThis.NavLink = NavLink;
globalThis.Route = Route;
globalThis.Switch = Switch;
// import modules common to browser and server side rendering (ssr)
// environments from application_common.js
import './application_common.js';

// import init_app from 'react_loader.js';
// init_app();
// globalThis.Opal.load('react_loader');
