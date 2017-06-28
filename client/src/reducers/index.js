import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';

import chess from './chessReducer';
import request from './requestReducer';

export default combineReducers({
  chess, 
  request,
  routing: routerReducer
});