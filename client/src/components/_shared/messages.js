import React from 'react';
import { currentPlayer } from '../../utils/helper';

const Messages = (props) => {

  const playerName = currentPlayer(props.white, props.black).name;

  const message = () => {
    if(props.game.status === 'check') {
      return <span>  |  Check!</span>;
    } else {
      return '';
    }
  };

  return (

    <div className="Messages">
      <p><span>Now Playing: {playerName}</span>{message()}</p>
    </div>

  )

}

export default Messages;