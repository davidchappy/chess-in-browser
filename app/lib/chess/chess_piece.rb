module Chess  

  class Piece

    def self.positions
    # Hash of starting piece positions by color
      {
        white: {
          rooks: ["a1", "h1"],
          knights: ["b1", "g1"],
          bishops: ["c1", "f1"],
          queen: ["d1"],
          king: ["e1"],
          pawns: ["a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2"],
        },
        black: {
          rooks: ["a8", "h8"],
          knights: ["b8", "g8"],
          bishops: ["c8", "f8"],
          queen: ["d8"],
          king: ["e8"],
          pawns: ["a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7"],
        }
      }
    end

    def get_type(piece)
      case piece.type
        when "Rook"
          return Chess::Piece::Rook.new
        when "Knight"
          return Chess::Piece::Knight.new
        when "Bishop"
          return Chess::Piece::Bishop.new
        when "Queen"
          return Chess::Piece::Queen.new
        when "King"
          return Chess::Piece::King.new
        when "Pawn"
          return Chess::Piece::Pawn.new
      end
    end
    
    # return move or empty hash for a possible scenario
    def self.get_piece_moves(board, piece)
      piece_type = Chess::Piece.new.get_type(piece)
      piece_moves = piece_type.moves(board, piece)
      piece_moves.each do |destination, flags|
        if Chess::Piece.new.check?(piece, destination, board)
          flags << "check" 
        end
      end 

      # process_captures(piece_moves)
      return piece_moves
    end

    # for queen, bishop and rook
    def generate_paths_for(offsets, board, piece)
      moves = {}
      offsets.each do |offset|
        i = 1
        last_tile = piece.position
        # max length of a path in any direction is 7
        7.times do |n|
          next_tile ||= ""
          adjusted_offset = offset * i     
          coords = offsets_to_coordinates([adjusted_offset], board, piece)
          next_tile = coords unless coords.nil?
          move = { next_tile => [] }
          case 
          when wrapped?(next_tile, last_tile)
            break
          when chess_board.is_piece?(next_tile, board)
            if next_tile != "" && chess_board.is_enemy?(next_tile, piece.color, board) 
              move[next_tile] << "capturing"
              moves.merge!( move ) 
              break
            else
              break
            end
          else
            moves.merge!( move ) unless next_tile == ""
          end
          i += 1
          last_tile = next_tile
        end
      end
      moves
    end

    # returns list of tiles matching key offsets or string if singular
    def offsets_to_coordinates(offsets, board, piece)
      coordinates = []
      current_position_index = coord_to_index(board, piece)

      offsets.each do |offset|
        adjusted_index = current_position_index + offset
        tile = board.keys[adjusted_index].to_s if adjusted_index.between?(0,63)
        coordinates << tile
      end

      if coordinates.length == 1
        return coordinates[0]
      else
        return coordinates
      end
    end

    # helper to convert coordinate to index
    def coord_to_index(board, piece)
      all_coordinates = board.keys
      index = all_coordinates.index(piece.position.to_sym)    
    end

    # helper to ensure possible moves don't include wrapped tiles
    def wrapped?(next_tile, last_tile)
      return false if next_tile.nil? || last_tile.nil?
      if next_tile[0] == "h" && last_tile[0] == "a"
        return true
      elsif next_tile[0] == "a" && last_tile[0] == "h"
        return true
      elsif next_tile[1] == "1" && last_tile[1] == "8"
        return true
      elsif next_tile[1] == "8" && last_tile[1] == "1"
        return true
      else 
        return false
      end
    end

    def chess_board
      board = Chess::Board.new
    end

    def check?(piece, move, board)
      destination = move
      pretend_piece = piece
      pretend_piece.position = destination.to_s
      pretend_board = board
      pretend_board[destination] = pretend_piece
      king = board.select{|t, val| val if val && val != "" && val.type == "King" && val.color != piece.color}.values[0]

      piece_type = get_type(pretend_piece)
      moves = piece_type.moves(pretend_board, pretend_piece)

      if moves.keys.include?(king.position)
        return true
      else 
        return false
      end
    end

    class Pawn < Piece

      def moves(board, piece)
        possible_moves = {}
        offsets = []
        left = offsets_to_coordinates([-1], board, piece)
        right = offsets_to_coordinates([1], board, piece)

        # allow 2 movements forward at start, diagonal capturing, and en_passant
        if piece.color == "white"
          in_front = offsets_to_coordinates([-8], board, piece)
          two_in_front = offsets_to_coordinates([-16], board, piece)
          front_left = offsets_to_coordinates([-9], board, piece)
          front_right = offsets_to_coordinates([-7], board, piece)
          unless chess_board.is_piece?(in_front, board)
            offsets << -8
            offsets << -16 if piece.position[1] == "2" && !chess_board.is_piece?(two_in_front, board)
          end
          offsets << -9 if !front_left.nil? && chess_board.is_enemy?(front_left, "white", board)
          offsets << -7 if !front_right.nil? && chess_board.is_enemy?(front_right, "white", board)
          if chess_board.en_passant?(piece, board)
            offsets << -9 if !left.nil? && chess_board.is_enemy?(left, "white", board)
            offsets << -7 if !right.nil? && chess_board.is_enemy?(right, "white", board)
          end
        elsif piece.color == "black"
          in_front = offsets_to_coordinates([8], board, piece)
          two_in_front = offsets_to_coordinates([16], board, piece)
          front_left = offsets_to_coordinates([9], board, piece)
          front_right = offsets_to_coordinates([7], board, piece)
          unless chess_board.is_piece?(in_front, board)
            offsets << 8
            offsets << 16 if piece.position[1] == "7" && !chess_board.is_piece?(two_in_front, board)
          end
          offsets << 9 if !front_left.nil? && chess_board.is_enemy?(front_left, "black", board)
          offsets << 7 if !front_right.nil? && chess_board.is_enemy?(front_right, "black", board)
          if chess_board.en_passant?(piece, board)
            offsets << 7 if !left.nil? && chess_board.is_enemy?(left, "black", board)
            offsets << 9 if !right.nil? && chess_board.is_enemy?(right, "black", board)
          end
        end

        legal_moves = offsets_to_coordinates(offsets, board, piece)
        if legal_moves.class == Array
          legal_moves.each { |move| possible_moves[move] = [] unless chess_board.obstructed?(move, piece.color, board) }
        else
          possible_moves[legal_moves] = [] unless chess_board.obstructed?(legal_moves, piece.color, board)
        end
        possible_moves
      end

    end

    class Rook < Piece

      def moves(board, piece)
        offsets = [-8,-1,1,8]
        rook_moves = generate_paths_for(offsets, board, piece)
      end

    end

    class Knight < Piece

      def moves(board, piece)
        possible_moves = {}
        offsets = [-17,-15,-10,-6,6,10,15,17]
        moves = offsets_to_coordinates(offsets, board, piece)
        moves.each do |move| 
          if move.nil? || piece.position.nil?
            next
          elsif knight_wrapped?(move, piece.position)
            next
          elsif chess_board.obstructed?(move, piece.color, board)
            next
          else
            possible_moves[move] = []
          end
        end
        possible_moves
      end

      def knight_wrapped?(next_tile, last_tile)
        letters = ("a".."h").to_a
        numbers = ("1".."8").to_a

        file_offset = letters.index(next_tile[0]) - letters.index(last_tile[0])
        rank_offset = numbers.index(next_tile[1]) - numbers.index(last_tile[1])

        if(next_tile[0] == last_tile[0] || 
            next_tile[1] == last_tile[1] || 
            file_offset > 2 || 
            file_offset < -2 || 
            rank_offset > 2 || rank_offset < -2)
          return true
        else
          return false
        end                 
      end

    end

    class Bishop < Piece

      def moves(board, piece)
        offsets = [-9,-7,7,9]
        bishop_moves = generate_paths_for(offsets, board, piece)
      end

    end

    class Queen < Piece

      def moves(board, piece)
        offsets = [-9,-8,-7,-1,1,7,8,9]
        queen_moves = generate_paths_for(offsets, board, piece)
      end

    end

    class King < Piece

      def moves(board, piece)
        possible_moves = {}
        offsets = [-9,-8,-7,-1,1,7,8,9]
        legal_moves = offsets_to_coordinates(offsets, board, piece)
        legal_moves.each do |move| 
          unless chess_board.obstructed?(move, piece.color, board) || move.nil?
            possible_moves[move] = [] 
          end
        end
        possible_moves
      end

    end

  end # end Piece class
      
end # end Chess module