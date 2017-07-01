module GamePrep
  extend ActiveSupport::Concern

  def generate_pieces(game)
    # create game pieces for each color
    2.times do |i|
      color = i == 0 ? "white" : "black"
      create_piece("Rook", color, "r1")
      create_piece("Rook", color, "r2")
      create_piece("Knight", color, "n1")
      create_piece("Knight", color, "n2")
      create_piece("Bishop", color, "b1")
      create_piece("Bishop", color, "b2")
      create_piece("King", color, "k")
      create_piece("Queen", color, "q")
      generate_pawns(color)
    end
    game
  end

  def position_pieces(game)
    Chess::Game.position_pieces(game.white_pieces).each(&:save!)
    Chess::Game.position_pieces(game.black_pieces).each(&:save!)
  end

  def init_board(game)
    Chess::Game.init_board(game).save!
    add_pieces_to_board(game)
  end

  private 

    def generate_pawns(color)
      8.times do |i|
        create_piece("Pawn", color, "p" + (i+1).to_s)
      end
    end

    def create_piece(type, color, suffix)
      self.pieces.create( type: type, color: color, name: color + "-" + suffix, position: "unplaced")
    end

    def add_pieces_to_board(game)
      board = game.board
      pieces = game.pieces
      pieces.each do |piece|
        position = piece.position.to_sym
        if board.keys.include?(position) 
          board[position] = piece.id
        end
      end
      game.board = board
      game.save!
    end

end