import React from 'react';
import { currentPlayer, otherPlayer } from '../../utils/helper';
import './messages.css';

const Messages = (props) => {

  const player = currentPlayer(props.white, props.black).name;
  const other = otherPlayer(props.white, props.black).name;

  const message = () => {
    if(props.game.status === 'check') {
      return <span>  |  Check!</span>;
    } else if(props.game.status === 'check_mate') {
      return <span>  |  Check Mate! {other} wins!</span> 
    } else {
      return '';
    }
  };

  return (

    <div className="Messages">
      <span>Now Playing: {player}</span>{message()}
    </div>

  )

}

export default Messages;