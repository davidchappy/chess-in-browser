import React from 'react';
import { currentPlayer, otherPlayer } from '../../utils/helper';

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
      <p><span>Now Playing: {player}</span>{message()}</p>
    </div>

  )

}

export default Messages;