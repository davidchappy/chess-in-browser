import { applyMiddleware, createStore, compose } from 'redux';
import { routerMiddleware } from 'react-router-redux';
import createHistory from 'history/createBrowserHistory';
import thunk from "redux-thunk";  
import { createLogger } from "redux-logger";
import promise from "redux-promise-middleware";
import reducer from './reducers';

export const history = createHistory();

const initialState = {};
const enhancers = [];
// const middleware = applyMiddleware(promise(), thunk, createLogger());
const middleware = [
  promise(),
  thunk,
  routerMiddleware(history),
  createLogger()
];

if (process.env.NODE_ENV === 'development') {
  const devToolsExtension = window.devToolsExtension;

  if (typeof devToolsExtension === 'function') {
    enhancers.push(devToolsExtension());
  }
}

const composedEnhancers = compose(
  applyMiddleware(...middleware),
  ...enhancers
);

const store = createStore(
  reducer, 
  initialState,
  composedEnhancers
);

export default store;