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
      }
    }
    case 'CREATE_GUEST_GAME_REJECTED': {
      return { ...state, fetching: false, error: action.payload.data}
    }
    case 'SELECT_PIECE': {
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
        fetched: true
      }
    }
    case 'MOVE_PIECE_REJECTED': {
      return {...state, fetching: false, error: action.payload.data}
    }
    case 'UPDATE_GAME_STATE': {
      return {
        ...state,
        white: action.payload.white,
        black: action.payload.black,
        game: action.payload.game
      }
    }
    case 'EAGER_UPDATE_GAME_STATE': {
      return {
        ...state,
        game: action.payload 
      }
    }
    default: {
      return state;
    }
  }
}