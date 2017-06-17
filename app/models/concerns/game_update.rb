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
    map_moves(game, moves)
    game.save!
    game
  end

  private

    # Add moves from hash to pieces
    def map_moves(game, moves)
      [game.white.pieces, game.black.pieces].each do |collection| 
        collection.each do |piece|
          piece.available_moves = moves[piece.name]
          piece.save!
          game.board[piece.position.to_sym] = piece
        end
      end
      game.save!
    end
end