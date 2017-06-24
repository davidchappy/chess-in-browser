import React from 'react';
import Board from '../board';
import './table.css';

const Table = (props) => {
  return (
    <div className="Table">
      <Board {...props}/>
    </div>
  )
};

export default Table;