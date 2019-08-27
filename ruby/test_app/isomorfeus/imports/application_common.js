// import javascript modules common to browser and server side rendering environments
import * as Redux from 'redux';
global.Redux = Redux;
import React from 'react';
global.React = React;
import * as ReactRouter from 'react-router';
import * as ReactRouterDOM from 'react-router-dom';
global.ReactRouter = ReactRouter;
global.ReactRouterDOM = ReactRouterDOM;
import { createUseStyles, useTheme as RuseTheme, ThemeProvider as RThemeProvider } from 'react-jss';
global.ReactJSS = { createUseStyles: createUseStyles, useTheme: RuseTheme, ThemeProvider: RThemeProvider };
import * as Mui from '@material-ui/core'
import { makeStyles, useTheme as MuseTheme, ThemeProvider as MThemeProvider } from '@material-ui/styles'
global.Mui = Mui;
global.MuiStyles = { makeStyles: makeStyles, useTheme: MuseTheme, ThemeProvider: MThemeProvider };
import * as Formik from 'formik';
global.Formik = Formik;

if (module.hot) { module.hot.accept(); }
