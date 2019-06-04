// import javascript modules common to browser and server side rendering environments
import * as Redux from 'redux';
global.Redux = Redux;
import React from 'react';
global.React = React;
import * as ReactRouter from 'react-router';
import * as ReactRouterDOM from 'react-router-dom';
global.ReactRouter = ReactRouter;
global.ReactRouterDOM = ReactRouterDOM;

if (module.hot) { module.hot.accept(); }
