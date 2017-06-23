import React from 'react';
import ReactDOM from 'react-dom';
import registerServiceWorker from './registerServiceWorker';

import { Provider } from 'react-redux';
import { ConnectedRouter } from 'react-router-redux';
import { Route } from 'react-router-dom';
import store, { history } from './store';

import App from './components/App';
import Game from './components/Game';
import Welcome from './components/Welcome';

import './index.css';

ReactDOM.render(
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <div>
        <Route exact path='/' component={App}/>
        <Route path='/game' component={Game} />
        <Route path='/welcome' component={Welcome} />
      </div>
    </ConnectedRouter> 
  </Provider>, 
  document.getElementById('root')
);

registerServiceWorker();



