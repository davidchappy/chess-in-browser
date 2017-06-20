module Chess

  class Game
    include PieceMethods

    # Returns a player's pieces with initial positions
    def self.position_pieces(pieces)
      color = pieces.first.color
      positions = starting_positions(pieces, color) 
      pieces.each do |piece|
        piece.position = positions[piece.id] if positions.keys.include?(piece.id)
      end
      pieces
    end

    # Generate game.board (coord hash)
    def self.init_board(game)
      game.board = generate_board
      game 
    end

    # Return hash of all moves for a player given current state of game board 
    def self.get_moves(game, player)
      # keys: piece names
      # values: hash of available moves
      all_moves = {}
      player.pieces.each do |piece|
        all_moves[piece.name] = {}
        game.board.keys.each do |tile|
          move = Chess::Piece.process_move(tile, game.board, piece)
          if move != {}
            all_moves[piece.name].merge!(move)  
          end
        end
      end
      get_castle_moves(game, all_moves)

      all_moves      
    end

    # Accept move and update board and pieces accordingly
    def self.update_board(game, move)
      new_board = game.board.clone
      # move is a hash ( from => from_tile, to => to_tile, flags => flags )
      from  = move["from"]
      to    = move["to"]
      flags = move["flags"].split(" ") if move["flags"]     
      piece = new_board[from.to_sym] unless new_board[from.to_sym] == ""

      # empty start square
      new_board[from.to_sym] = ""

      # evaluate scenarios
      case 
      when flags.nil? || flags.empty? || flags == ""
      when flags.include("castling")
        castle(new_board, piece, to)
      when flags.include("en_passant")
        process_en_passant(new_board, piece, to)
      when flags.include("capturing")
        process_capturing(new_board, piece, to)
      when flags.include("promoting")
        process_promotion(new_board, piece, to)
      end
      # always move piece 
      process_movement(new_board, piece, to)

      game.board = new_board
      game
    end

    # Assign board's piece positions to player's pieces and return pieces
    def self.update_pieces(player, board)
      player.pieces.each do |piece|
        board_piece = board.select{|t, val| val if val != "" && val.name == piece.name}.values[0]
        if(piece.position != board_piece.position)
          piece.has_moved = true
          piece.position = board_piece.position
        end
      end
      player.pieces
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
        letters=("a".."h").to_a.reverse
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

      def process_en_passant(board, piece, to)
      end

      def process_capturing(board, piece, to)
      end

      def process_promotion(board, piece, to)
      end

      def process_movement(board, piece, to)
        piece.position = to
        board[to.to_sym] = piece
      end

      # Helper helpers
      
      # Return false or array of left/right castelable opportunities
      def castleable?(game)
        castleable = []
        king = current_player(game).pieces.where(type: "King").take
        rooks = current_player(game).pieces.where(type: "Rook").to_a
        left_rook = rooks.select{ |r| r if r.position == "a8" || r.position == "a1" }[0]
        right_rook = rooks.select{ |r| r if r.position == "h8" || r.position == "h1" }[0]
        rooks.each { |rook| rooks.delete(rook) if rook.has_moved }

        if current_player(game) == game.white
          left_side = game.board.keys.select{ |t| game.board[t] if t == :d1 || t == :c1 || t == :b1 }
          right_side = game.board.keys.select{ |t| game.board[t] if t == :f1 || t == :g1 }     
        else 
          left_side = game.board.keys.select{ |t| game.board[t] if t == :d8 || t == :c8 || t == :b8 }
          right_side = game.board.keys.select{ |t| game.board[t] if t == :f8 || t == :g8 }  
        end

        case
        when king.has_moved || rooks.length == 0
          return false
        when left_side.any?{ |t| game.board[t] != "" } && right_side.any?{ |t| game.board[t] != "" }
          return false
        when rooks.length == 1
          if left_side.all?{ |t| game.board[t] != "" } && left_rook.has_moved == false
            castleable[0] = true
            castleable[1] = false 
          end
          if right_side.all?{ |t| game.board[t] != "" } && right_rook.has_moved == false
            castleable[0] ||= false 
            castleable[1] = true 
          end
        when rooks.length == 2
          castleable[0] = left_side.all?{ |t| game.board[t] != "" } ? true : false
          castleable[1] = right_side.all?{ |t| game.board[t] != "" } ? true : false
        else
          return false
        end

        if castleable == [] || castleable.nil?
          return false
        else
          return castleable
        end
      end # End castleable?

      # General helpers
      def current_player(game)
        return [game.white, game.black].select { |p| p if p.is_playing }[0]
      end

    end
  end

end # end Chess module