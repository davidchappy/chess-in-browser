import axios from 'axios';
import { push } from 'react-router-redux';
import * as types from './actionTypes';

export function createGuestGame(guest1, guest2) {
  return function(dispatch) {
    dispatch(serverRequested());
    
    return axios.post('/api/games', {
      guest1: guest1,
      guest2: guest2
    })
    .then(response => {
      dispatch(updateGameState(response.data));
      dispatch(serverFulfilled());
      push('/game');
    })
    .catch(error => {
      dispatch(serverRejected(error));
    })
  }
}

export function selectPiece(piece) {
  return {
    type: types.SELECT_PIECE, 
    payload: piece
  }
}

export function movePiece(selectedMove, game, pieces) {
  const move = {
    from: selectedMove.from,
    to: selectedMove.to,
    flags: selectedMove.flags
  }

  return function(dispatch) {
    // dispatch(eagerUpdateGameState(move, game, pieces));
    dispatch(serverRequested());

    return axios.put(`/api/games/${game.id}`, {move})
    .then(response => {
      dispatch(updateGameState(response.data));
      dispatch(serverFulfilled());
    })
    .catch(error => {
      dispatch(serverFulfilled(error));
    })
  }
}


// ** Private **

// Update UI with move rather than waiting on server response
function eagerUpdateGameState(move, game, pieces) {
  const board = Object.assign({}, game.board);
  const board_piece = Object.assign({}, game.board[move.from]);
  board_piece.position = move.to;
  board[move.to] = board_piece;
  board[move.from] = "";

  const updated_game = JSON.parse(JSON.stringify(game));
  updated_game.board = board;

  const piece = pieces.find(p => p.name === board_piece.name);
  const index = pieces.indexOf(piece);
  piece.position = move.to;
  pieces[index] = piece;

  return {
    type: types.EAGER_UPDATE_GAME_STATE, 
    payload: { game: updated_game, pieces: pieces }
  }
}

function updateGameState(data) {
  return {
    type: types.UPDATE_GAME_STATE, 
    payload: data
  }
}

function serverRequested() {
  return {
    type: types.SERVER_REQUESTED
  }
}

function serverFulfilled() {
  return {
    type: types.SERVER_FULFILLED
  }
}

function serverRejected(response) {
  return {
    type: types.SERVER_REJECTED,
    payload: response
  }
}