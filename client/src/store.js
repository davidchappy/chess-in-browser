// Store
import { applyMiddleware, createStore, compose } from 'redux';
import reducer from './reducers';

// Routing
import { routerMiddleware } from 'react-router-redux';
import createHistory from 'history/createBrowserHistory';

// Middleware
import thunk from "redux-thunk";  
import { createLogger } from "redux-logger";
import promise from "redux-promise-middleware";


// Gather store elements
export const history = createHistory();

const initialState = {};
const enhancers = [];
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

// Export
export default store;