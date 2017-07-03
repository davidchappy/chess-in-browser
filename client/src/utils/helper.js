export function currentPlayer(white, black) {
  return white.is_playing ? white : black;
}