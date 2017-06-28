import React from 'react';
import './intro.css';

const Intro = (props) => {
  return (
    <p className="Welcome-intro">
      <button onClick={() => props.createGuestGame()}>Start Game As Guest</button>
    </p>
  )
};

export default Intro;

