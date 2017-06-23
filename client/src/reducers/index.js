import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';

// // Import individual reducers
import chess from './chessReducer';

export default combineReducers({
  chess, 
  routing: routerReducer
});