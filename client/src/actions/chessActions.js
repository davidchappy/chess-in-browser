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
      console.log(response);
      dispatch({type: 'CREATE_GUEST_GAME_FULFILLED', payload: response});
      push('/game');
    })
    .catch(error => {
      console.log(error);
      dispatch({type: 'CREATE_GUEST_GAME_REJECTED', payload: error});
    })
  }
}