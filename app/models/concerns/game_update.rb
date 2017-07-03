module GameUpdate
  extend ActiveSupport::Concern

  def get_moves(game)
    purge_moves(game)
    moves = Chess::Game.get_moves(game)
    # If no valid moves, declare check mate
    game.status = 'check_mate' if moves.size == 0
    map_moves(game, moves)
    game
  end

  def set_status(status="playing")
    self.status = status
    self.save!
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

  def update_board(game, move)
    Chess::Game.update_board(game, move).save!
  end

  def update_pieces(game)
    Chess::Game.update_pieces(game).each(&:save!)
  end

  private

    def purge_moves(game)
      game.pieces.each do |piece|
        piece.moves.destroy_all
      end
    end

    # Add moves from hash to pieces as Move instances
    def map_moves(game, moves)
      # moves is a nested hash
      game.current_pieces.each do |piece|
        if moves.has_key?(piece.name)
          piece_moves = moves[piece.name]
          piece_moves.each do |destination, flags|
            if flags.class == String
              if flags == ""
                flags = [] 
              else 
                flags = flags.to_a
              end
            end
            piece.moves.create!(from: piece.position, to: destination, flags: flags) unless destination.nil?
          end
        end
      end
      game.save!
    end
end