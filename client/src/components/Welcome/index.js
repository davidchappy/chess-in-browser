import React, { Component } from 'react';
import Header from '../_shared/header';
import Intro from './intro';

export default class Welcome extends Component {
  constructor(props) {
    super(props);
  
    this.state = {};
  }

  createGuestGame() {
    this.props.createGuestGame("Alex", "Lucas");
  }

  render() {
    return (
      <div className="Welcome">
        <Header {...this.props} welcome={true} />
        <Intro createGuestGame={this.createGuestGame.bind(this)} />
      </div>
    )
  }
}