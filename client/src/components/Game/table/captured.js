import React from 'react';
import Piece from '../pieces/piece';
import './captured.css';

const Captured = (props) => {
  let pieces;
  if(props.pieces) {
    pieces = props.pieces.map(piece => {
      if(piece.color === props.color && piece.position == 'captured') {
        return (
          <li><Piece piece={piece} /></li>
        )
      }
    });
  } else {
    pieces = null;
  }


  return (
    <ul className={"captured " + "captured-" + props.color}>{pieces}</ul>
  )
}

export default Captured;