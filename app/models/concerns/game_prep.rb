module GamePrep
  extend ActiveSupport::Concern

  def generate_pieces(game)
    # Void function to fill both players with pieces
    [game.white, game.black].each do |player|
      2.times { player.pieces.create(game: game, type: "Rook") }
      2.times { player.pieces.create(game: game, type: "Knight") }
      2.times { player.pieces.create(game: game, type: "Bishop") }
      player.pieces.create(game: game, type: "King") 
      player.pieces.create(game: game, type: "Queen") 
      generate_pawns(player, game)
    end
    game.save!
    return nil
  end

  private 

    def generate_pawns(player, game)
      # Void function to create pawns for a player
      8.times { player.pieces.create(game: game, type: "Pawn") }
      return nil
    end

end