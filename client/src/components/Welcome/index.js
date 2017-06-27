import React from 'react';
import './Welcome.css';
import Header from '../shared/header';

const Welcome = (props) => {
  return (
    <div className="Welcome">
      <Header {...props} welcome={true} />
      <p className="Welcome-intro">
        <button onClick={() => props.createGuestGame("Alex", "Lucas")}>Start Game As Guest</button>
      </p>
    </div>
  )
}

export default Welcome;