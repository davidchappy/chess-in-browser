import axios from 'axios';
import { push } from 'react-router-redux';

export function createGuestGame(guest1, guest2) {
  return function(dispatch) {
    dispatch({type: 'CREATE_GUEST_GAME'});
    axios.post('/api/games', {
      guest1: guest1,
      guest2: guest2
    })
    .then(response => {
      dispatch({type: 'CREATE_GUEST_GAME_FULFILLED', payload: response});
      push('/game');
    })
    .catch(error => {
      console.log(error);
      dispatch({type: 'CREATE_GUEST_GAME_REJECTED', payload: error});
    })
  }
}

export function selectPiece(piece) {
  console.log('selectPiece piece', piece);

  return function(dispatch) {
    dispatch({type: 'SELECT_PIECE', payload: piece});
  }
}

export function movePiece(selectedMove, gameId) {
  console.log("selectedMove", selectedMove);

  const move = {
    from: selectedMove.from,
    to: selectedMove.to,
    flags: selectedMove.flags
  }

  return function(dispatch) {
    dispatch({type: 'MOVE_PIECE'});
    axios.put(`/api/games/${gameId}`, {move})
    .then(response => {
      console.log(response);
      dispatch({type: 'MOVE_PIECE_FULFILLED', payload: response});
    })
    .catch(error => {
      console.log(error);
      dispatch({type: 'MOVE_PIECE_REJECTED', payload: error});
    })
  }
}