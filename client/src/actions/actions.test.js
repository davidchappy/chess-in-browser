import React from 'react';
import configureMockStore from 'redux-mock-store';
import thunk from 'redux-thunk';
import nock from 'nock';
import axios from 'axios';
import httpAdapter from 'axios/lib/adapters/http';
import * as actions from './chessActions';
import * as types from './actionTypes';

const middlewares = [thunk];
const mockStore = configureMockStore(middlewares);

const host = 'http://localhost';

axios.defaults.host = host;
axios.defaults.adapter = httpAdapter;

// axios and nock don't play well together
// https://github.com/node-nock/nock/issues/699// 
describe('actions', () => {
  afterEach(() => {
    nock.cleanAll();
  });

  describe('createGuestGame', () => {
    it('creates correct actions when creating Guest game', () => {
      const gameData = {
        game: { id: 1 },
        black: { id: 2 },
        white: { id: 3 }
      }

      nock(host)
        .post('/api/games')
        .reply(201, {
          data: gameData
        });

      const expectedActions = [
        { type: types.SERVER_REQUESTED },
        { type: types.UPDATE_GAME_STATE, payload: { data: gameData } },
        { type: types.SERVER_FULFILLED },
      ] 
      const store = mockStore({ 
        game: {},
        white: {},
        black: {}
      })

      return store.dispatch(actions.createGuestGame('Fred', 'Ethel')).then(() => {
        expect(store.getActions()).toEqual(expectedActions);
      }) 
    });
  });

  describe('movePiece', () => {
    it('creates correct actions when moving piece', () => {
      const piece = { position: "a2", name: "a piece" };
      const pieceAfterMove = { ...piece, position: "a3" };

      const gameData = {
        game: {
          id: 1,
          board: { "a2": piece },
        },
        pieces: [piece] 
      }

      const updatedGameData = {
        game: {
          id: 1,
          board: {
            "a2": "",
            "a3": pieceAfterMove
          },
        },
        pieces: [pieceAfterMove]
      }

      const move = {
        from: "a2",
        to: "a3",
        flags: ""
      }

      nock(host)
        .put('/api/games/1')
        .reply(200, {
          data: updatedGameData
        });

      const expectedActions = [
        { type: types.EAGER_UPDATE_GAME_STATE, payload: updatedGameData },
        { type: types.SERVER_REQUESTED },
        { type: types.UPDATE_GAME_STATE, payload: { data: updatedGameData } },
        { type: types.SERVER_FULFILLED },
      ] 
      const store = mockStore({ 
        game: {},
      })

      return store.dispatch(actions.movePiece(move, gameData.game, gameData.pieces)).then(() => {
        expect(store.getActions()).toEqual(expectedActions);
      }) 
    });
  });

  describe('selectPiece', () => {
    it('creates correct actions when selecting piece', () => {
      const piece = { position: "a2", name: "a piece" };
      const expectedAction = { 
        type: types.SELECT_PIECE, 
        payload: piece 
      };
      expect(actions.selectPiece(piece)).toEqual(expectedAction);
    });
  })

});