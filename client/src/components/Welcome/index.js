import React from 'react';
import './welcome.css';
import logo from './logo.svg';


const Welcome = (props) => {
  let loadingClass = props.fetching ? " loading" : " loaded"

  return (
    <div className="Welcome">
      <div className="Welcome-header">
        <img src={logo} className={"Welcome-logo" + loadingClass} alt="logo" />
        <h2>Welcome to Chess</h2>
      </div>
      <p className="Welcome-intro">
        <button onClick={() => props.createGuestGame("Alex", "Lucas")}>Start Game As Guest</button>
      </p>
    </div>
  )
}

export default Welcome;