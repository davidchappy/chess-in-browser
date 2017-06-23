import React, { Component } from 'react';
import './board.css';
import Tiles from './tiles';

class Board extends Component {
  render() {
    return (
      <div className="Board">
        <Tiles />
      </div>
    )
  }
}

export default Board;