module Chess

  class Game
    include PieceMethods

    # Returns a player's pieces with initial positions
    def self.position_pieces(pieces)
      color = pieces.first.color
      positions = starting_positions(pieces, color)

      pieces.each do |piece|
        piece.position = positions[piece.id]
      end
      pieces
    end

    # Generate game.board (coord hash)
    def self.init_board(game)
      game.board = generate_board
      game 
    end

    # Return hash of all moves for a player given current state of game board 
    def self.get_moves(game)
      # keys: piece names
      # values: nested hash of available moves
      all_moves = {}

      if game.status == 'check'
        all_moves = Chess::Piece.get_check_moves(game)
      else 
        all_moves = Chess::Piece.get_piece_moves(game)
      end 

      # get_castle_moves(game, all_moves)
      all_moves      
    end

    # Accept move and update board and pieces accordingly
    def self.update_board(game, move)
      new_board = game.board.clone
      # move is a hash ( from => from_tile, to => to_tile, flags => flags )
      from  = move["from"]
      to    = move["to"]
      flags = move["flags"].flatten if move["flags"]     
      piece = new_board[from.to_sym] unless new_board[from.to_sym] == ""

      # empty out the start square
      new_board[from.to_sym] = ""

      # evaluate scenarios
      case 
      when flags.nil? || flags.empty? || flags == "" || flags == [""]
      when flags.include?("check")
        puts "setting status to check"
        game.set_status("check")
      when flags.include?("castling")
        castle(new_board, piece, to)
      when flags.include?("en_passant")
        en_passant(new_board, piece, to)
      when flags.include?("capture")
        capture(new_board, piece, to)
      when flags.include?("promotion")
        game.status = "promoting"
      end
      # always move piece 
      move(new_board, piece, to)

      game.board = new_board
      game
    end

    # Assign board's piece positions to player's pieces and return pieces
    def self.update_pieces(game)
      board  = game.board
      pieces = game.pieces

      pieces.each do |piece|
        board_position = game.position_by_id(piece.id)
        if(piece.position != board_position)
          piece.has_moved = true
          piece.position = board_position
        end
      end
      game.pieces = pieces
    end

    # Private
    
    class << self
      def get_castle_moves(game, all_moves)
        castle_moves = Chess::Board.new.castle_moves(game)
        if castle_moves != {}
          king_name = castle_moves.first[0]
          all_moves[king_name].merge!(castle_moves.first[1])
        end
        all_moves
      end 

      # Startup helpers
      def starting_positions(pieces, color)
        positions = Piece.positions[color.to_sym]
        return map_piece_positions(pieces, positions)
      end   

      # Returns hash where keys = piece ids, values = tile positions
      def map_piece_positions(pieces, positions)
        mapped_positions = {}
        pieces.each do |piece|
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
        letters=("a".."h").to_a
        letters.each do |letter|
          board[(letter + num.to_s).to_sym] = ""
        end
      end

      # Move helpers
      def castle(board, piece, to)
        king = piece
        case king.color
        when 'white'
          board[:e1] = ""
          if to == 'g1'
            rook = board[:h1]
            board[:h1] = ""
            board[:f1] = rook
            board[:g1] = king
          elsif to == 'c1'
            rook = board[:a1]
            board[:a1] = ""
            board[:d1] = rook
            board[:c1] = king
          end
        when 'black'
          board[:e8] = ""
          if to == 'g8'
            rook = board[:h8]
            board[:h8] = ""
            board[:f8] = rook
            board[:g8] = king
          elsif to == 'c8'
            rook = board[:a8]
            board[:a8] = ""
            board[:d8] = rook
            board[:c8] = king
          end
        end
      end

      def en_passant(board, piece, to)
        
      end

      def capture(board, piece, to)
        captured_piece = board[to.to_sym]
        captured_piece = game.pieces.select{|p| p if p.id == captured_piece.id }.first
        captured_piece.position = "captured"
      end

      def move(board, piece, to)
        board[to.to_sym] = piece
        # piece position is not changed here but in .update_pieces
      end

      # Helper helpers

      def current_player(game)
        return [game.white, game.black].select { |p| p if p.is_playing }[0]
      end

    end
  end

end # end Chess module