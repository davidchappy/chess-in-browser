module GamePrep

  included do
    helper_method :generate_pieces
    helper_method :create_guests
  end

  def generate_pieces(game)
    # Void function to fill both players with pieces
    game.white.pieces << Rook.create(game: game) 
    game.white.pieces << Knight.create(game: game) 
    game.white.pieces << Bishop.create(game: game)
    game.white.pieces << King.create(game: game) 
    game.white.pieces << Queen.create(game: game) 
    game.white.pieces << Bishop.create(game: game) 
    game.white.pieces << Knight.create(game: game)
    game.white.pieces << Rook.create(game: game)

    game.black.pieces << Rook.create(game: game) 
    game.black.pieces << Knight.create(game: game) 
    game.black.pieces << Bishop.create(game: game) 
    game.black.pieces << King.create(game: game) 
    game.black.pieces << Queen.create(game: game) 
    game.black.pieces << Bishop.create(game: game) 
    game.black.pieces << Knight.create(game: game) 
    game.black.pieces << Rook.create(game: game)

    generate_pawns(game)
    game.save!

    return nil
  end

  def create_guests(name1, name2)
    # Create Guest players and randomize order
    player1 = Guest.create(name: name1)
    player2 = Guest.create(name: name2)
    [player1, player2].shuffle
  end

  private 

    def generate_pawns(game)
      # Void function to create pawns for both colors
      [game.white, game.black].each do |player|
        # Ensure pieces array exists
        8.times do 
          player.pieces << Pawn.create(game: game, player: player) 
        end
      end
      return nil
    end

end