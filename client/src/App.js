import React, { Component } from 'react';
import axios from 'axios';
import logo from './logo.svg';
import './App.css';

class App extends Component {
  constructor(props) {
    super(props);
  
    this.state = {
      white: undefined,
      black: undefined,
      game: undefined
    };
  }

  componentDidMount() {
      axios.post('/api/games', {
        guest1: "Fred",
        guest2: "Ethel"
      })
      .then((response) => {
        console.log(response.data)
        this.setState({
          white: response.data.white,
          black: response.data.black,
          game: response.data.game
        })
      })
      .catch((error) => {
        console.log(error)
      })
  }

  render() {
    return (
      <div className="App">
        <div className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h2>Welcome to React</h2>
        </div>
        <p className="App-intro">
          To get started, edit <code>src/App.js</code> and save to reload.
        </p>
      </div>
    );
  }
}

export default App;
