import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import Table from './table/';
import Header from '../_shared/header';
import { selectPiece, movePiece } from '../../actions/chessActions';

export class Game extends Component {
  constructor(props) {
    super(props);
  
    this.state = {};
  }
  
  render() {
    return (
      <div className="Game">
        <Header {...this.props} headerSize="small" />
        <Table {...this.props} />
      </div>  
    )
  }
}

const mapStateToProps = (state, ownProps) => {
  return {
    game: state.chess.game,
    white: state.chess.white,
    black: state.chess.black,
    pieces: state.chess.pieces,
    board: state.chess.board,
    selectedPiece: state.chess.selectedPiece,
    selectableTiles: state.chess.selectableTiles,
    fetching: state.request.fetching,
    fetched: state.request.fetched
  }
}

const mapDispatchToProps = dispatch => bindActionCreators({
  selectPiece,
  movePiece
}, dispatch);

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Game)
