export default function chessReducer(state={
  fetched: false,
  fetching: false,
  error: null,
  white: undefined,
  black: undefined,
  game: undefined
}, action) {
  switch (action.type) {
    case 'CREATE_GUEST_GAME': {
      return {...state, fetching: true}
    }
    case 'CREATE_GUEST_GAME_FULFILLED': {
      return {
        ...state,
        fetching: false,
        fetched: true,
        white: action.payload.data.white,
        black: action.payload.data.black,
        game: action.payload.data.game
      }
    }
    case 'CREATE_GUEST_GAME_REJECTED': {
      return { ...state, fetching: false, error: action.payload.data}
    }
    default: {
      return state;
    }
  }
}