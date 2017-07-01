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
    
    # return move or empty hash for a possible scenario
    def self.get_piece_moves(piece, game)
      board = game.board
      piece_type = Chess::Piece.new.get_type(piece)
      piece_moves = piece_type.moves(piece, game)
      piece_moves.each do |destination, flags|
        if Chess::Piece.new.check?(piece, destination, game)
          flags << "check" 
        end
      end 

      # process_captures(piece_moves)
      return piece_moves
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

    # for queen, bishop and rook
    def generate_paths_for(offsets, piece, game)
      board = game.board
      pieces = game.pieces
      moves = {}
      offsets.each do |offset|
        i = 1
        last_tile = piece.position
        # max length of a path in any direction is 7
        7.times do |n|
          next_tile ||= ""
          adjusted_offset = offset * i     
          coords = offsets_to_coordinates([adjusted_offset], piece, game)
          next_tile = coords unless coords.nil?
          move = { next_tile => [] }
          case 
          when wrapped?(next_tile, last_tile)
            break
          when chess_board.is_piece?(next_tile, game)
            if next_tile != "" && chess_board.is_enemy?(next_tile, piece.color, game) 
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
    def offsets_to_coordinates(offsets, piece, game)
      board = game.board
      pieces = game.pieces
      coordinates = []
      current_position_index = coord_to_index(piece, board)

      offsets.each do |offset|
        adjusted_index = current_position_index + offset
        tile = board.keys[adjusted_index].to_s if adjusted_index.between?(0,63)
        coordinates << tile
      end

      if coordinates.length == 1
        return coordinates[0]
      else
        return coordinates.compact
      end
    end

    # helper to convert coordinate to index
    def coord_to_index(piece, board)
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

    def check?(piece, destination, game)
      # Copy values to create pretend scenario
      pretend_piece = piece.dup
      pretend_piece.position = destination.to_s
      # game.board[destination] = pretend_piece.id
      king_color = pretend_piece.color == 'white' ? 'black' : 'white'
      king = game.pieces.where(type: 'King', color: king_color).take.dup

      piece_type = get_type(pretend_piece)
      moves = piece_type.moves(pretend_piece, game)

      if moves.keys.include?(king.position)
        return true
      else 
        return false
      end
      false
    end

    # Piece moves stored in pieces/piece_*.rb

  end # end Piece class
      
end # end Chess module