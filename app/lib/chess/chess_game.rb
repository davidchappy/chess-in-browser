module Chess

  class Game
    include PieceMethods

    def self.test(string)
      puts string
    end

    def self.place_pieces(pieces, color)
      # assign starting positions to each piece in array for given color
      positions = starting_positions(pieces, color)
      pieces.each do |piece|
        piece.position = positions[piece.id] if positions.keys.include?(piece.id)
      end
      pieces
    end

    def self.fill_board(game)
      game.board = generate_board
      pieces = game.white.pieces + game.black.pieces
      add_pieces_to_board(game.board, pieces)
      game 
    end

    def self.update(game, move)
      # update game.board with move
        # check? check mate?
        # en passant?
        # castling?
        # capture?
        # promotion?
      chess_game.place_pieces(game, positions)
    end

    # Private
    
    class << self
    
      def starting_positions(pieces, color)
        positions = Piece.positions[color]
        return map_piece_positions(pieces, positions)
      end   

      def map_piece_positions(pieces, positions)
        mapped_positions = {}
        pieces.map do |piece|
          position = ""
          case piece.type
          when "Rook"
            position = positions[:rooks].delete_at(0)
          when "Knight"
            position = positions[:knights].delete_at(0)
          when "Bishop"
            position = positions[:bishops].delete_at(0)
          when "King"
            position = positions[:king].delete_at(0)
          when "Queen"
            position = positions[:queen].delete_at(0)
          when "Pawn"
            position = positions[:pawns].delete_at(0)
          end
          mapped_positions[piece.id] = position
        end
        mapped_positions
      end

      def generate_board
        board = {}
        8.downto(1).each do |number|
          fill_row(number, board)
        end
        board
      end

      def fill_row(num, board)
        letters=("a".."h")
        letters.to_a.each do |letter|
          board[(letter + num.to_s).to_sym] = ""
        end
      end

      def add_pieces_to_board(board, pieces)
        pieces.each do |piece|
        position = piece.position.to_sym
        if board.keys.include?(position) 
            board[position] = piece
          end
        end
      end

    end
  end

end