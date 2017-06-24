export default function chessReducer(state={
  fetched: false,
  fetching: false,
  moving: false,
  selectableTiles: [],
  selectedPiece: undefined,
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
    case 'SELECT_PIECE': {
      console.log('action.payload', action.payload);

      return {
        ...state, 
        moving: true,
        selectableTiles: action.payload.moves.map(tile => tile.to),
        selectedPiece: action.payload 
      }
    }
    case 'MOVE_PIECE': {
      return {
        ...state, 
        fetching: true,
        moving: false,
        selectableTiles: [],
        selectedPiece: undefined
      }
    }
    case 'MOVE_PIECE_FULFILLED': {
      return {
        ...state,
        fetching: false,
        fetched: true,
        white: action.payload.data.white,
        black: action.payload.data.black,
        game: action.payload.data.game
      }
    }
    case 'MOVE_PIECE_REJECTED': {
      return {...state, fetching: false, error: action.payload.data}
    }
    default: {
      return state;
    }
  }
}