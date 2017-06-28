import * as types from '../actions/actionTypes';

const initialState = {
  selectableTiles: [],
  selectedPiece: {},
  white: {},
  black: {},
  game: {},
  pieces: [],
  board: {},
}

export default function chessReducer(state=initialState, action) {
  switch (action.type) {
    case types.SELECT_PIECE: {
      return {
        ...state, 
        selectableTiles: action.payload.moves.map(tile => tile.to),
        selectedPiece: action.payload 
      }
    }
    case types.UPDATE_GAME_STATE: {
      return {
        ...state,
        white: action.payload.white,
        black: action.payload.black,
        game: action.payload.game,
        pieces: action.payload.game.pieces,
        board: action.payload.game.board
      }
    }
    case types.EAGER_UPDATE_GAME_STATE: {
      return {
        ...state,
        game: action.payload,
        pieces: action.payload.pieces,
        board: action.payload.board,
        selectableTiles: [],
        selectedPiece: undefined 
      }
    }
    default: {
      return state;
    }
  }
}