import React from 'react';
import './piece.css';

const Piece = (props) => {
  const type = props.piece.type.toLowerCase() + " ";
  const color = props.piece.color + " ";

  let selectableClass = "", clickable = {};
  if(props.piece.moves.length) {
    selectableClass = 'selectable ';
    clickable = {
      onClick: props.selectPiece.bind(this, props.piece)
    }
  }

  return (
    <div  className={"Piece " + type + color + selectableClass + props.position }
          {...clickable} >
    </div>
  )
};

export default Piece;