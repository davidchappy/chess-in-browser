import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { createGuestGame } from '../actions/chessActions';
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

const mapStateToProps = (state, ownProps) => {
  return {
    fetching: state.request.fetching,
    fetched: state.request.fetched,
  }
}

const mapDispatchToProps = dispatch => bindActionCreators({
  createGuestGame
}, dispatch);

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(App)