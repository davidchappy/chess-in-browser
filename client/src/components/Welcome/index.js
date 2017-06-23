import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { createGuestGame } from '../../actions/chessActions';
import { Link } from 'react-router-dom';

class Welcome extends Component {
  constructor(props) {
    super(props);
  
    this.state = {};
  }

  render() {
    return (
      <div>
        <p>Hello from Welcome!</p>
        <Link to="/">App</Link> 
        <button onClick={() => this.props.createGuestGame("Alex", "Lucas")}>Start Game As Guest</button>
      </div>
    )
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
  createGuestGame
}, dispatch);

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Welcome)