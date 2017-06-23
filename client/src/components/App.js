import React, { Component } from 'react';
import { connect } from 'react-redux';
import { createGuestGame } from '../actions/chessActions';
import logo from './logo.svg';
import './App.css';
import { push } from 'react-router-redux';
import { bindActionCreators } from 'redux';

class App extends Component {
  constructor(props) {
    super(props);
  
    this.state = {};
  }

  render() {
    let loadingClass = this.props.fetching ? " loading" : " loaded"
    // let loadingClass = " loading";

    return (
      <div className="App">
        <div className="App-header">
          <img src={logo} className={"App-logo" + loadingClass} alt="logo" />
          <h2>Welcome to React</h2>
        </div>
        <p className="App-intro">
          To get started, edit <code>src/App.js</code> and save to reload.
          <button onClick={() => this.props.createGuestGame("Alex", "Lucas")}>Start Game As Guest</button>
        </p>
        <button onClick={() => this.props.goToGame()}>Go to Game page via redux</button>
        <button onClick={() => this.props.goToWelcome()}>Go to Welcome page via redux</button>
      </div>
    );
  }
}

const mapStateToProps = (state, ownProps) => {
  return {
    fetching: state.chess.fetching,
    fetched: state.chess.fetched,
    game: state.chess.game,
    white: state.chess.white,
    black: state.chess.black 
  }
}

const mapDispatchToProps = dispatch => bindActionCreators({
  goToGame: () => push('/game'),
  goToWelcome: () => push('/welcome'),
  createGuestGame
}, dispatch);

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(App)

// const mapDispatchToProps = (dispatch) => {
//   return {
//     createGuestGame: (guest1, guest2) => {
//       dispatch(createGuestGame(guest1, guest2))
//     }
//   }
// }

// export default connect(mapStateToProps, mapDispatchToProps)(App);