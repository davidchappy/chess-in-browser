import axios from 'axios';
import { push } from 'react-router-redux';
import * as types from './actionTypes';

export function createGuestGame(guest1, guest2) {
  return function(dispatch) {
    dispatch({type: types.SERVER_REQUESTED});
    
    axios.post('/api/games', {
      guest1: guest1,
      guest2: guest2
    })
    .then(response => {
      console.log(response);
      dispatch(updateGameState(response.data));
      dispatch({type: types.SERVER_FULFILLED});
      push('/game');
    })
    .catch(error => {
      console.log(error);
      dispatch({type: types.SERVER_REJECTED, payload: error});
    })
  }
}

export function updateGameState(data) {
  return function(dispatch) {
    dispatch({type: types.UPDATE_GAME_STATE, payload: data});
  }
}

// Update UI with move rather than waiting on server response
export function eagerUpdateGameState(move, game) {
  const board = Object.assign({}, game.board);
  const board_piece = Object.assign({}, game.board[move.from]);
  board_piece.position = move.to;
  board[move.to] = board_piece;
  board[move.from] = "";

  const updated_game = JSON.parse(JSON.stringify(game));
  const game_piece = updated_game.pieces.find(p => p.name === board_piece.name);
  game_piece.position = move.to;
  updated_game.board = board;

  return function(dispatch) {
    dispatch({type: types.EAGER_UPDATE_GAME_STATE, payload: updated_game});
  }
}

export function selectPiece(piece) {
  console.log('selectPiece piece', piece);

  return function(dispatch) {
    dispatch({type: types.SELECT_PIECE, payload: piece});
  }
}

export function movePiece(selectedMove, game) {
  const move = {
    from: selectedMove.from,
    to: selectedMove.to,
    flags: selectedMove.flags
  }

  return function(dispatch) {
    // dispatch({type: 'EAGER_UPDATE_GAME_STATE', payload: updated_game});
    dispatch(eagerUpdateGameState(move, game));
    dispatch({type: types.SERVER_REQUESTED});
    dispatch({type: types.MOVE_PIECE});

    axios.put(`/api/games/${game.id}`, {move})
    .then(response => {
      console.log(response);
      dispatch(updateGameState(response.data));
      dispatch({type: types.SERVER_FULFILLED});
    })
    .catch(error => {
      console.log(error);
      dispatch({type: types.SERVER_REJECTED, payload: error});
    })
  }
}