import React from 'react';
import Board from '../board';
import Captured from './captured';
import './table.css';

const Table = (props) => {
  return (
    <div className="Table">
      <Captured {...props} color="white"/>
      <Board {...props}/>
      <Captured {...props} color="black"/>
    </div>
  )
};

export default Table;