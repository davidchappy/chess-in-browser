module GamePrep
  extend ActiveSupport::Concern

  def generate_pieces(game)
    # fill both players with pieces
    [game.white, game.black].each_with_index do |player, i|
      color = i == 0 ? "white" : "black"
      create_piece(player, game, "Rook", color, "r1")
      create_piece(player, game, "Rook", color, "r2")
      create_piece(player, game, "Knight", color, "n1")
      create_piece(player, game, "Knight", color, "n2")
      create_piece(player, game, "Bishop", color, "b1")
      create_piece(player, game, "Bishop", color, "b2")
      create_piece(player, game, "King", color, "k")
      create_piece(player, game, "Queen", color, "q")
      generate_pawns(player, game, color)
    end
    game.save!
  end

  def add_pieces(game)
    Chess::Game.place_pieces(game.white.pieces, :white).each(&:save!)
    Chess::Game.place_pieces(game.black.pieces, :black).each(&:save!)
  end

  def fill_board(game)
    Chess::Game.fill_board(game).save!
  end

  private 

    def generate_pawns(player, game, color)
      # create pawns for a player
      8.times do |i|
        create_piece(player, game, "Pawn", color, "p" + (i+1).to_s)
      end
    end

    def create_piece(player, game, type, color, suffix)
      player.pieces.create( game: game, type: type, 
                            color: color, name: color+"-" + suffix)
    end

end