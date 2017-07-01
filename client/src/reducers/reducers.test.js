import * as types from '../actions/actionTypes';
import reducer from './index';

const initialState = {
  chess: {
    selectableTiles: [],
    selectedPiece: {},
    white: {},
    black: {},
    game: {},
    pieces: [],
    board: {},
  },
  request: {
    fetched: false,
    fetching: false,
    error: null,
  },
  routing: {
    location: null
  }
}

describe('chess reducer', () => {
  it('should return the initial state', () => {
    expect(reducer(undefined, {})).toEqual(initialState)
  });

  it('should handle UPDATE_GAME_STATE', () => {
    const game = { 
      id: 1, 
      board: { "a2": { id: 1, position: "a2" } },
      pieces: [ {id:1, position: "a2"} ],
    }
    const gameData = {
      white: { id: 1 },
      black: { id: 2 },
      game: game,
      pieces: game.pieces,
      board: game.board
    }

    expect(
      reducer({}, {
        type: types.UPDATE_GAME_STATE,
        payload: gameData
      })
    ).toEqual({
      ...initialState,
      chess: {
        ...initialState.chess,
        ...gameData
      }
    })
  });

  it('should handle EAGER_UPDATE_GAME_STATE', () => {
    const data = {
      game: {
        id: 1, 
        board: { "a2": { id: 1, position: "a2" } },
      },      
      pieces: [ {id:1, position: "a2"} ]
    }

    expect(
      reducer({}, {
        type: types.EAGER_UPDATE_GAME_STATE,
        payload: data
      })
    ).toEqual({
      ...initialState,
      chess: {
        ...initialState.chess,
        game: data.game,
        board: data.game.board,
        pieces: data.pieces,
        selectableTiles: [],
        selectedPiece: undefined 
      }
    })
  });

  it('should handle SELECT_PIECE', () => {
    const piece = { 
      id:1, 
      position: "a2",
      moves: [{to: "a3"}]
    }

    expect(
      reducer({}, {
        type: types.SELECT_PIECE,
        payload: piece
      })
    ).toEqual({
      ...initialState,
      chess: {
        ...initialState.chess,
        selectableTiles: piece.moves.map(tile => tile.to),
        selectedPiece: piece
      }
    })
  });
});



describe('request reducer', () => {
  it('should return the initial state', () => {
    expect(reducer(undefined, {})).toEqual(initialState)
  });

  it('should handle SERVER_REQUESTED', () => {
    expect(
      reducer({}, {type: types.SERVER_REQUESTED})
    ).toEqual({
      ...initialState,
      request: {
        ...initialState.request,
        fetching: true,
      }
    })
  });

  it('should handle SERVER_FULFILLED', () => {
    expect(
      reducer({}, {type: types.SERVER_FULFILLED})
    ).toEqual({
      ...initialState,
      request: {
        ...initialState.request,
        fetching: false,
        fetched: true,
      }
    })
  });

  it('should handle SERVER_REJECTED', () => {
    const error = {
      error: "error"
    }

    expect(
      reducer({}, { type: types.SERVER_REJECTED, payload: { data: error } })
    ).toEqual({
      ...initialState,
      request: {
        ...initialState.request,
        fetching: false, 
        error: error
      }
    })
  });
});