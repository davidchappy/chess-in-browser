import React from 'react';
import './board.css';
import Tile from './tile';

const Board = (props) => {

  // create 2-dim. array with tile rows from game.board data
  const tileNames = Object.keys(props.board);
  let row = [], allRows = [];
  for(let i=0; i<tileNames.length; i++) {
    let tile = tileNames[i];
    if(i === 0 || i % 8 !== 0) {
      row.push(tile);
    } else {
      allRows.push(row);
      row = [];
      row.push(tile);
    }
    if (i === tileNames.length-1) {
      allRows.push(row);
    } 
  }

  const allPieces = props.pieces;
  // map through 2dim array of tiles and return rows of Tiles
  const tiles = allRows.map((rowArray, i) => {
    let rowType = i % 2 === 0 ? 0 : 1;
    let row = rowArray.map((tile, i) => {
      const color = i % 2 === rowType ? 'light' : 'dark';
      let piece = null;
      if(props.board[tile] !== "") {
        for(let pieceNo in allPieces) {
          if(allPieces[pieceNo].position === tile) {
            piece = allPieces[pieceNo];
          }
        }
      }
      const selectable = props.selectableTiles.includes(tile) ? true : false; 
      return (<Tile {...props} tile={tile} key={i} 
                    color={color} piece={piece} 
                    selectable={selectable} />)
    })
    return (
      <div key={i} className="tileRow">
        {row}
      </div>
    )
  });

  return (
    <div className="Board">
      <div className="tiles">
        {tiles}
      </div>
    </div>
  )

}

export default Board;