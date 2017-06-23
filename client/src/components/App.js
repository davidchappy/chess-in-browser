import React, { Component } from 'react';
import { connect } from 'react-redux';
import { createGuestGame } from '../actions/chessActions';
import './App.css';
// import { push } from 'react-router-redux';
import { bindActionCreators } from 'redux';
// import { Route, Switch } from 'react-router-dom';
import Game from './Game';
import Welcome from './Welcome';

export class App extends Component {
  constructor(props) {
    super(props);
  
    this.state = {};
  }

  render() {
    let page;

    if(this.props.fetched) {
      page = () => {
        return (
          <Game />
        )
      }
    } else {
      page = () => {
        return (
          <Welcome fetching={this.props.fetching} 
                   createGuestGame={this.props.createGuestGame}/>
        )
      }
    }

    return (
      <div className="App">
        {page()}
      </div>
    );
  }
}

//         <Switch>
//   <Route exact path='/' component={Welcome} />
//   <Route exact path='/game' component={Game} />
// </Switch>

const mapStateToProps = (state, ownProps) => {
  return {
    fetching: state.chess.fetching,
    fetched: state.chess.fetched,
  }
}

const mapDispatchToProps = dispatch => bindActionCreators({
  createGuestGame
}, dispatch);

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(App)