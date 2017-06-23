import React from 'react';
import './tiles.css';
import Tile from './tile';

const Tiles = (props) => {
  return (
    <div className="Tiles">
      <div className="tileRow">
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
      </div>
      <div className="tileRow">
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
      </div>
      <div className="tileRow">
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
      </div>
      <div className="tileRow">
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
      </div>
      <div className="tileRow">
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
      </div>
      <div className="tileRow">
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
      </div>
      <div className="tileRow">
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
      </div>
      <div className="tileRow">
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
        <Tile color="dark"/>
        <Tile color="light"/>
      </div>
    </div>
  )
};

export default Tiles;