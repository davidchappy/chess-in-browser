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
    def self.get_piece_moves(game)
      board = game.board
      all_moves = {}
      piece_logic = Chess::Piece.new

      game.current_pieces.each do |piece|
        # Don't get moves for a captured piece
        next if piece.position == 'captured'

        # If game is in check, assign (limited) moves
        piece_type = piece_logic.get_type(piece)
        if piece.type == 'King'
          king_moves = piece_type.moves(piece, game)
          piece_moves = piece_logic.filter_king_moves(king_moves, game)
        else
          piece_moves = piece_type.moves(piece, game)
        end 
        piece_moves.each do |destination, flags|
          if Chess::Piece.new.check?(piece, destination, game)
            flags << "check" 
          end
          if Chess::Board.new.is_enemy?(destination, piece.color, game)
            flags << "capturing" 
          end
        end 

        # Get available moves for this piece and add to all_moves hash
        all_moves[piece.name] = piece_moves unless piece_moves == {} || piece_moves.nil? 
      end

      # process_captures(piece_moves)
      
      all_moves
    end

    def self.get_check_moves(game, last_move)
      all_moves = {}
      piece_logic = Chess::Piece.new
      attacker = game.find_on_board(last_move["to"])
      king = game.current_king
      
      attacker_type = piece_logic.get_type(attacker)
      attacker_moves = attacker_type.moves(attacker, game)
      
      attacker_moves.each do |tile, flags|
        game.current_pieces.each do |piece|
          next if piece.position == 'captured'
          piece_type = piece_logic.get_type(piece)
          if piece.type == 'King'
            king_moves = piece_type.moves(piece, game)
            piece_moves = piece_logic.filter_king_moves(king_moves, game)
          else
            piece_moves = piece_type.moves(piece, game)
          end 
          piece_moves.each do |tile, flags|
            if piece_logic.blocks_path?(tile, attacker, king)
              all_moves[piece.name] ||= {}
              all_moves[piece.name].merge!({ tile => flags })
            end
          end
        end
      end

      all_moves
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
      coordinates = []
      current_position_index = coord_to_index(piece, board)
      if current_position_index.nil?
        byebug
      end

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

    def blocks_path?(tile, attacker, attacked)
      path_types = ["Rook", "Bishop", "Queen"]
      between = false

      if path_types.include?(attacker.type) 
        between = chess_board.between_tiles?(tile, attacker.position, attacked.position)
      end

      return true if between || tile == attacker.position
      false
    end

    def filter_king_moves(king_moves, game)
      game.other_pieces.each do |piece|
        next if piece.position == 'captured'
        piece_type = Chess::Piece.new.get_type(piece)
        piece_moves = piece_type.moves(piece, game)
        piece_moves.each do |tile, flags|
          king_tiles = king_moves.map{ |t,f| t  }
          king_moves.delete(tile) if king_tiles.include?(tile)
        end
      end
      king_moves
    end

    # Piece moves stored in pieces/piece_*.rb

  end # end Piece class
      
end # end Chess module