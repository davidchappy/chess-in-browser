module Chess  

  class Piece

    def self.positions
    # Hash of starting piece positions by color
      {
        white: {
          rooks: ["a1", "h1"],
          knights: ["b1", "g1"],
          bishops: ["c1", "f1"],
          king: ["e1"],
          queen: ["d1"],
          pawns: ["a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2"],
        },
        black: {
          rooks: ["a8", "h8"],
          knights: ["b8", "g8"],
          bishops: ["c8", "f8"],
          king: ["e8"],
          queen: ["d8"],
          pawns: ["a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7"],
        }
      }
    end
    
    def self.process_move(destination, board, piece)
      # destination is symbol
      # if given destination is possible with current game board return { tile: ["flags"]}
      returned_moves = {}
      piece_type = case piece.type
        when "Rook"
          Chess::Piece::Rook.new
        when "Knight"
          Chess::Piece::Knight.new
        when "Bishop"
          Chess::Piece::Bishop.new
        when "Queen"
          Chess::Piece::Queen.new
        when "King"
          Chess::Piece::King.new
        when "Pawn"
          Chess::Piece::Pawn.new
      end
      piece_moves = piece_type.moves(board, piece)
      if piece_moves.keys.include?(destination.to_s)
        returned_moves.merge!({ destination.to_s => piece_moves[destination.to_s] })
      end
      # process_captures(returned_moves)
      return returned_moves
    end

    # for queen, bishop and rook
    def generate_paths_for(offsets, board, piece)
      path_tiles = {}
      offsets.each do |offset|
        i = 1
        # max length of a path in any direction is 7
        7.times do |n|
          next_tile ||= nil
          last_tile = next_tile
          adjusted_offset = offset * i     
          next_tile = offsets_to_coordinates([adjusted_offset], board, piece)
          case 
          when next_tile.nil? || wrapped?(next_tile, last_tile)
            break
          when chess_board.is_piece?(next_tile, board)
            if chess_board.is_enemy?(next_tile, piece.color, board)
              path_tiles.merge!( { next_tile => ["capturing"] } )
              break
            else
              break
            end
          end
          path_tiles.merge!( { next_tile => [""] } )
          i += 1
        end
      end
      path_tiles
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
        legal_moves.each { |move| possible_moves[move] = "" unless chess_board.obstructed?(move, piece.color, board) }
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
        legal_moves = offsets_to_coordinates(offsets, board, piece)
        legal_moves.each do |move| 
          possible_moves[move] = "" unless chess_board.obstructed?(move, piece.color, board)
        end
        possible_moves
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
        legal_moves.each { |move| possible_moves[move] = "" unless chess_board.obstructed?(move, piece.color, board) }
        possible_moves
      end

    end

  end # end Piece class
      
end # end Chess module