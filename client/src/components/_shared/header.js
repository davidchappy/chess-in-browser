import React from 'react';
import './header.css';
import './logo.css';
import logo from './logo.svg';
import Messages from './messages';

const Header = (props) => {
  const sizeClass = props.headerSize ? props.headerSize : 'large';

  let headerText = () => {
    if(props.welcome) {
      return <h2>Welcome to Chess</h2>;
    } else {
      return <Messages {...props} />;
    }
  }

  let loadingClass = props.fetching ? " loading" : " loaded";

  return (
    <div className={"chess-header " + sizeClass}>
      <img src={logo} className={"chess-logo" + loadingClass + " " + sizeClass} alt="logo" />
      {headerText()}
    </div>
  )
}

export default Header;