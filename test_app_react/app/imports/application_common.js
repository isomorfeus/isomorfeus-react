// import javascript modules common to browser and server side rendering environments
import React from 'react';
global.React = React;
import * as ReactRouter from 'react-router';
import * as ReactRouterDOM from 'react-router-dom';
global.ReactRouter = ReactRouter;
global.ReactRouterDOM = ReactRouterDOM;
import * as Formik from 'formik';
global.Formik = Formik;

if (module.hot) { module.hot.accept(); }
