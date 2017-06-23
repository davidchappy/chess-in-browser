import React from 'react';
import './tile.css';

import Piece from '../pieces/piece';

const Tile = (props) => {
  let tileColor = props.color;

  return (
    <div className={tileColor + " Tile"}>
      <Piece color="black" type="queen"/>
    </div>
  )
};

export default Tile;