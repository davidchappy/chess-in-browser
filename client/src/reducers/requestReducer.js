import * as types from '../actions/actionTypes';

const initialState = {
  fetched: false,
  fetching: false,
  error: null,
}

export default function requestReducer(state = initialState, action) {
  switch (action.type) {
    case types.SERVER_REQUESTED: {
      return {
        ...state, 
        fetching: true
      }
    }
    case types.SERVER_FULFILLED: {
      return {
        ...state,
        fetching: false,
        fetched: true,
      }
    }
    case types.SERVER_REJECTED: {
      return {
        ...state, 
        fetching: false, 
        error: action.payload.data
      }
    }
    default: {
      return {...state}
    }
  }
}