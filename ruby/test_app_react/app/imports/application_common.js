// import javascript modules common to browser and server side rendering environments
import * as Redux from 'redux';
global.Redux = Redux;
import React from 'react';
global.React = React;
import * as ReactRouter from 'react-router';
import * as ReactRouterDOM from 'react-router-dom';
global.ReactRouter = ReactRouter;
global.ReactRouterDOM = ReactRouterDOM;
import * as ReactJSS from 'react-jss';
global.ReactJSS = ReactJSS;
import * as Mui from '@material-ui/core'
import * as MuiStyles from '@material-ui/styles'
global.Mui = Mui;
global.MuiStyles = MuiStyles;
import * as Formik from 'formik';
global.Formik = Formik;
import * as Paper from 'react-native-paper';
global.Paper = Paper;

if (module.hot) { module.hot.accept(); }
