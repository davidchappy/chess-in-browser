import React, { Component } from 'react';
import './game.css';
import Table from './table/';

const Game = () => {
  return (
    <div className="Game">
      <h1>Chess</h1>
      <Table />
    </div>  
  )
}

export default Game;
