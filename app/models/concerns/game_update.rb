module GameUpdate
  extend ActiveSupport::Concern

  def get_moves(last_move=nil)
    # 
    # move_definitions = Chess::Game.describe_moves(game_state)
    purge_moves
    moves = Chess::Game.get_moves(self, last_move)
    # If no valid moves, declare check mate
    self.status = 'check_mate' if moves.size == 0
    save_moves(moves)
    self
  end

  def set_status(status="playing")
    self.status = status
    self.save!
  end

  def set_turn 
    if self.white.is_playing
      self.white.is_playing = false
      self.black.is_playing = true
    elsif self.black.is_playing
      self.white.is_playing = true
      self.black.is_playing = false
    else 
      self.white.is_playing = true
    end
    self.white.save!
    self.black.save!
  end

  def update_board(move)
    self.set_status('playing') if status == 'check' && !move["flags"].include?("check")
    Chess::Game.update_board(self, move).save!
  end

  def update_pieces
    Chess::Game.update_pieces(self).each(&:save!)
  end

  private

    def purge_moves
      self.pieces.each do |piece|
        piece.moves.destroy_all
      end
    end

    # Add moves from hash to pieces as Move instances
    def save_moves(moves)
      # moves is a nested hash
      self.current_pieces.each do |piece|
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
      self.save!
    end
    
end