export function currentPlayer(white, black) {
  return white.is_playing ? white : black;
}

export function otherPlayer(white, black) {
  return white.is_playing ? black : white;
}