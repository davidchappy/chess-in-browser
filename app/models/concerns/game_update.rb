module GameUpdate
  extend ActiveSupport::Concern

  def set_status(game, status="playing")
    game.status = status
    game.save!
  end

  def set_turn(white, black) 
    if white.is_playing
      white.is_playing = false
      black.is_playing = true
    elsif black.is_playing
      white.is_playing = true
      black.is_playing = false
    else 
      white.is_playing = true
    end
    white.save!
    black.save!
  end

  def get_moves(game)
    moves = Chess::Game.get_moves(game)
    [game.white, game.black].each { |p| map_moves_to_player(moves, p) }
    game.save!
    game
  end

  private

    def map_moves_to_player(moves, player)
      player.pieces.each do |piece|
        piece.available_moves = moves[piece.name]
        piece.save!
      end
      player.save!
    end
end