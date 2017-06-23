import React from 'react';
import './piece.css';

const Piece = (props) => {
  const type = props.type;
  const color = props.color;

  return (
    <div className={"Piece " + type + " " + color}>
    </div>
  )
};

export default Piece;