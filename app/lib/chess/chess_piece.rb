module Chess  

  class Piece

    def generate_pieces_definitions
      piece_definitions = []
      2.times do |i|
        color = i == 0 ? "white" : "black"
        piece_definitions << piece_definition("Rook", color, "r1")
        piece_definitions << piece_definition("Rook", color, "r2")
        piece_definitions << piece_definition("Knight", color, "n1")
        piece_definitions << piece_definition("Knight", color, "n2")
        piece_definitions << piece_definition("Bishop", color, "b1")
        piece_definitions << piece_definition("Bishop", color, "b2")
        piece_definitions << piece_definition("Queen", color, "q")
        piece_definitions << piece_definition("King", color, "k")
        generate_pawns(piece_definitions, color)
      end
      piece_definitions
    end

    # return move or empty hash for a possible scenario
    def get_piece_moves(game)
      board = game.board
      all_moves = {}

      game.current_pieces.each do |piece|
        # Don't get moves for a captured piece
        next if piece.position == 'captured'

        # If game is in check, assign (limited) moves
        piece_type = get_type(piece)
        if piece.type == 'King'
          king_moves = piece_type.moves(piece, game)
          piece_moves = filter_king_moves(king_moves, game)
        else
          piece_moves = piece_type.moves(piece, game)
        end 
        piece_moves.each do |destination, flags|
          if check?(piece, destination, game)
            flags << "check" 
          end
          if chess_board.is_enemy?(destination, piece.color, game)
            flags << "capturing" 
          end
        end 

        # Get available moves for this piece and add to all_moves hash
        all_moves[piece.name] = piece_moves unless piece_moves == {} || piece_moves.nil? 
      end

      # process_captures(piece_moves)
      
      all_moves
    end

    def get_check_moves(game, last_move)
      all_moves = {}
      attacker = game.find_on_board(last_move["to"])
      king = game.current_king
      
      attacker_type = get_type(attacker)
      attacker_moves = attacker_type.moves(attacker, game)
      
      attacker_moves.each do |tile, flags|
        game.current_pieces.each do |piece|
          next if piece.position == 'captured'
          piece_type = get_type(piece)
          if piece.type == 'King'
            king_moves = piece_type.moves(piece, game)
            piece_moves = filter_king_moves(king_moves, game)
          else
            piece_moves = piece_type.moves(piece, game)
          end 
          piece_moves.each do |tile, flags|
            if blocks_path?(tile, attacker, king)
              all_moves[piece.name] ||= {}
              all_moves[piece.name].merge!({ tile => flags })
            end
          end
        end
      end

      all_moves
    end

    private

      def piece_definition(type, color, suffix)
        name = color + "-" + suffix
        position = positions[color.to_sym][suffix.to_sym]
        { type: type, color: color, name: name, position: position }
      end

      def generate_pawns(set, color)
        8.times do |i|
          set << piece_definition("Pawn", color, "p" + (i+1).to_s)
        end
      end

      def positions
      # Hash of starting piece positions by color
        {
          white: {
            r1: "a1",
            r2: "h1",
            n1: "b1",
            n2: "g1",
            b1: "c1",
            b2: "f1",
            k:  "e1",
            q:  "d1",
            p1: "a2",
            p2: "b2",
            p3: "c2",
            p4: "d2",
            p5: "e2",
            p6: "f2",
            p7: "g2",
            p8: "h2"
          },
          black: {
            r1: "a8",
            r2: "h8",
            n1: "b8",
            n2: "g8",
            b1: "c8",
            b2: "f8",
            k:  "e8",
            q:  "d8",
            p1: "a7",
            p2: "b7",
            p3: "c7",
            p4: "d7",
            p5: "e7",
            p6: "f7",
            p7: "g7",
            p8: "h7"
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
        # if current_position_index.nil?
        #   byebug
        # end

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
        Chess::Board.new
      end

      def chess_piece
        Chess::Piece.new
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
          piece_type = get_type(piece)
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