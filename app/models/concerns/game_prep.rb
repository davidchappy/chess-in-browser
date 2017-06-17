module GamePrep
  extend ActiveSupport::Concern

  def generate_pieces(game)
    # fill game's (associated) players with (associated) pieces
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

  def position_pieces(game)
    Chess::Game.position_pieces(game.white.pieces).each(&:save!)
    Chess::Game.position_pieces(game.black.pieces).each(&:save!)
  end

  def init_board(game)
    Chess::Game.init_board(game).save!
    add_pieces_to_board(game)
  end

  private 

    def generate_pawns(player, game, color)
      8.times do |i|
        create_piece(player, game, "Pawn", color, "p" + (i+1).to_s)
      end
    end

    def create_piece(player, game, type, color, suffix)
      player.pieces.create( type: type, color: color, name: color + "-" + suffix)
    end

    def add_pieces_to_board(game)
      board = game.board
      pieces = game.white.pieces + game.black.pieces
      pieces.each do |piece|
        position = piece.position.to_sym
        if board.keys.include?(position) 
          board[position] = piece
        end
      end
      game.save!
    end

end