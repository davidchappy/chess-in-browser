import React from 'react';
import './tile.css';
import Piece from '../pieces/piece';

const Tile = (props) => {
  const tileColor = props.color;

  // If tile is a selectable destination
  let selectedClass = "", clickable = {};
  if(props.selectable) {
    selectedClass = ' selectable';
    const move = props.selectedPiece.moves.find(move => {
      return move.to === props.tile
    })
    clickable = {
      onClick: props.movePiece.bind(this, move, props.game.id)
    }
  }

  // Render piece or empty div
  const piece = () => {
    if(props.piece) {
      return (
        <Piece {...props} />
      )
    } else {
      return (<div></div>)
    }
  } 

  return (
    <div className={"Tile " + tileColor + selectedClass} id={props.tile} {...clickable}>
      {piece()}
    </div>
  )
};

export default Tile;