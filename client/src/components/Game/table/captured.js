import React from 'react';
import Piece from '../pieces/piece';
import './captured.css';

const Captured = (props) => {
  let pieces;
  if(props.pieces) {
    pieces = props.pieces.map(piece => {
      if(piece.color === props.color && piece.position === 'captured') {
        return (
          <li key={piece.id}><Piece piece={piece} /></li>
        )
      } else {
        return null;
      }
    });
  } else {
    pieces = null;
  }

  const classes = "captured captured-" + props.color;


  return (
    <ul className={classes}>{pieces}</ul>
  )
}

export default Captured;