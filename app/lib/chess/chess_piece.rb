module Chess  

  class Piece

    def self.positions
    # Hash of starting piece positions by color
      {
        white: {
          rooks: ["a1", "h1"],
          knights: ["b2", "g1"],
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
    
    def possible_move?(destination, board)
      # check if given destination is possible with current game board
      return true if moves(board).include?(destination)
      false
    end

    # for knight and king
    def generate_adjacent_tiles(offsets)
      adjacent_tiles = []
      # get current position's index within array of tiles keys
      all_coordinates = Board.tiles.keys
      current_position_index = all_coordinates.index(@position.to_sym)

      offsets.each do |offset|
        adjusted_index = current_position_index + offset
        tile = all_coordinates[adjusted_index].to_s if adjusted_index.between?(0,63)
        adjacent_tiles << tile
      end

      adjacent_tiles
    end

    # for queen, bishop and rook
    def generate_paths_for(offsets, board)
      path_tiles = []
      all_coordinates = Board.tiles.keys
      current_position_index = all_coordinates.index(@position.to_sym)    

      offsets.each do |offset|
        i = 1
        # max length of a path in any direction is 7
        7.times do |n|   
          adjusted_offset = offset * i     
          next_tile = generate_adjacent_tiles([adjusted_offset])[0]
          case 
          when next_tile.nil? || wrapped?(next_tile, path_tiles)
            break
          when board.is_piece?(next_tile)
            if board.is_enemy?(next_tile, @color)
              path_tiles << next_tile
              break
            else
              break
            end
          end
          path_tiles << next_tile
          i += 1
        end
      end
      path_tiles
    end

    # helper to ensure possible moves don't include wrapped tiles
    def wrapped?(next_tile, path_tiles)
      return false if path_tiles.empty? || path_tiles.nil?
      last_tile_letter = path_tiles.last[0]
      next_tile_letter = next_tile[0]
      if next_tile_letter == "h" && last_tile_letter == "a"
        return true
      elsif next_tile_letter == "a" && last_tile_letter == "h"
        return true
      else 
        return false
      end
    end

    # helper that returns list of tiles matching key offsets or string if singular
    def offsets_to_coordinates(offsets)
      coordinates = []
      all_coordinates = Board.tiles.keys
      current_position_index = all_coordinates.index(@position.to_sym)

      offsets.each do |offset|
        adjusted_index = current_position_index + offset
        tile = all_coordinates[adjusted_index].to_s if adjusted_index.between?(0,63)
        coordinates << tile
      end

      if coordinates.length == 1
        return coordinates[0]
      else
        return coordinates
      end
    end

    class Pawn < Piece

      def initialize(color, position="")
        super
        @name = "pawn"
        @icon = get_icon(@color, @name)
      end

      def moves(board)
        possible_moves = []
        offsets = []
        left = offsets_to_coordinates([-1])
        right = offsets_to_coordinates([1])

        # allow 2 movements forward at start, diagonal capturing, and en_passant
        if @color == "white"
          in_front = offsets_to_coordinates([-8])
          two_in_front = offsets_to_coordinates([-16])
          front_left = offsets_to_coordinates([-9])
          front_right = offsets_to_coordinates([-7])
          unless board.is_piece?(in_front)
            offsets << -8
            offsets << -16 if @position[1] == "2" && !board.is_piece?(two_in_front)
          end
          offsets << -9 if !front_left.nil? && board.is_enemy?(front_left, "white")
          offsets << -7 if !front_right.nil? && board.is_enemy?(front_right, "white")
          if board.en_passant?(self)
            offsets << -9 if !left.nil? && board.is_enemy?(left, "white")
            offsets << -7 if !right.nil? && board.is_enemy?(right, "white")
          end
        elsif @color == "black"
          in_front = offsets_to_coordinates([8])
          two_in_front = offsets_to_coordinates([16])
          front_left = offsets_to_coordinates([9])
          front_right = offsets_to_coordinates([7])
          unless board.is_piece?(in_front)
            offsets << 8
            offsets << 16 if @position[1] == "7" && !board.is_piece?(two_in_front)
          end
          offsets << 9 if !front_left.nil? && board.is_enemy?(front_left, "black")
          offsets << 7 if !front_right.nil? && board.is_enemy?(front_right, "black")
          if board.en_passant?(self)
            offsets << 7 if !left.nil? && board.is_enemy?(left, "black")
            offsets << 9 if !right.nil? && board.is_enemy?(right, "black")
          end
        end

        legal_moves = generate_adjacent_tiles(offsets)
        legal_moves.each { |move| possible_moves << move unless board.obstructed?(move, @color) }
        possible_moves
      end

    end

    class Rook < Piece

      attr_accessor :has_moved

      def initialize(color, position="")
        super
        @name = "rook"
        @icon = get_icon(@color, @name)
        @has_moved ||= false
      end

      def moves(board)
        offsets = [-8,-1,1,8]
        generate_paths_for(offsets, board)
      end

    end

    class Knight < Piece

      def initialize(color, position="")
        super
        @name = "knight"
        @icon = get_icon(@color, @name)
      end

      def moves(board)
        possible_moves = []
        offsets = [-17,-15,-10,-6,6,10,15,17]
        legal_moves = generate_adjacent_tiles(offsets)
        legal_moves.each { |move| possible_moves << move unless board.obstructed?(move, @color) }
        possible_moves
      end

    end

    class Bishop < Piece

      def initialize(color, position="")
        super
        @name = "bishop"
        @icon = get_icon(@color, @name)
      end

      def moves(board)
        offsets = [-9,-7,7,9]
        generate_paths_for(offsets, board)
      end

    end

    class Queen < Piece

      def initialize(color, position="")
        super
        @name = "queen"
        @icon = get_icon(@color, @name)
      end

      def moves(board)
        offsets = [-9,-8,-7,-1,1,7,8,9]
        generate_paths_for(offsets, board)
      end

    end

    class King < Piece

      attr_accessor :has_moved

      def initialize(color, position="")
        super
        @name = "king"
        @icon = get_icon(@color, @name)
        @has_moved ||= false
      end

      def moves(board)
        possible_moves = []
        offsets = [-9,-8,-7,-1,1,7,8,9]
        legal_moves = generate_adjacent_tiles(offsets)
        legal_moves.each { |move| possible_moves << move unless board.obstructed?(move, @color) }
        possible_moves
      end

    end

  end # end Piece class
end # end Chess module