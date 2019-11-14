// import javascript modules common to browser and server side rendering environments
import * as Redux from 'redux';
global.Redux = Redux;
import React from 'react';
global.React = React;
import * as ReactRouter from 'react-router';
import * as ReactRouterDOM from 'react-router-dom';
import * as Mui from '@material-ui/core'
import * as MuiStyles from '@material-ui/styles'
import * as ReactJSS from 'react-jss';
global.ReactRouter = ReactRouter;
global.ReactRouterDOM = ReactRouterDOM;
global.Mui = Mui;
global.MuiStyles = MuiStyles;
global.ReactJSS = ReactJSS;

if (module.hot) { module.hot.accept(); }
