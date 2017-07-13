module Chess

  class Board

    def generate_board_definition
      board = {}
      8.downto(1).each do |number|
        fill_row(number, board)
      end
      board
    end

    def valid_tile?(coordinate, game)
      board = game.board
      return true if !coordinate.nil? && board.keys.include?(coordinate.to_sym)
      false
    end

    def open_tile?(coordinate, game)
      return true if valid_tile?(coordinate, game) && !is_piece?(coordinate, game)
      false
    end

    def is_piece?(coordinate, game)
      piece = game.find_on_board(coordinate)
      classes = [Piece, Rook, Bishop, Knight, King, Queen, Pawn]
      return true if !coordinate.nil? && coordinate != "" && classes.include?(piece.class)
      false
    end

    def is_enemy?(coordinate, player_color, game)
      piece = game.find_on_board(coordinate)
      return true if is_piece?(coordinate, game) && player_color != piece.color
      false
    end

    def obstructed?(coordinate, player_color, game)
      return true if is_piece?(coordinate, game) && !is_enemy?(coordinate, player_color, game)
      false
    end

    # Checks if tile is on direct path between start and end positions
    def between_tiles?(tile, start_position, end_position)
      same_file = start_position[0] == end_position[0]
      same_rank = start_position[1] == end_position[1]

      if same_file && tile[1].between?(start_position[1], end_position[1])
        return true
      elsif same_rank && tile[0].between?(start_position[0], end_position[0])
        return true
      elsif diagonal?(start_position, end_position)
        if( diagonal?(tile, start_position) &&
            diagonal?(tile, end_position)  &&
            tile[0].between?(start_position[0], end_position[0]) &&
            tile[1].between?(start_position[1], end_position[1]) )
          return true
        end
      end
      false
    end

    def diagonal?(start_position, end_position)
      start_file = start_position[0].ord
      start_rank = start_position[1].to_i
      end_file   = end_position[0].ord
      end_rank   = end_position[1].to_i

      return true if (start_file - end_file).abs == (start_rank - end_rank).abs
      false
    end

    def check_en_passant(pawn, game)
      board = game.board
      if pawn.type == "Pawn"
        col_as_num = pawn.position[0].ord
        row = pawn.position[1]
        right_position = "#{(col_as_num+1).chr}#{row}"
        left_position = "#{(col_as_num-1).chr}#{row}"
        if pawn.color == "white" && row == "4"
          return right_position if !board[right_position.to_sym].nil? && is_enemy?(right_position, pawn.color, game) 
          return left_position if !board[left_position.to_sym].nil? && is_enemy?(left_position, pawn.color, game) 
        elsif pawn.color == "black" && row == "5"
          return right_position if !board[right_position.to_sym].nil? && is_enemy?(right_position, pawn.color, game) 
          return left_position if !board[left_position.to_sym].nil? && is_enemy?(left_position, pawn.color, game) 
        end
      end
      false
    end

    def castle_moves(game)
      castleable = {}
      board = game.board
      player = game.current_player
      color = game.current_color
      pieces = game.current_pieces
      king = game.current_king
      castleable[king.name] = {}

      rooks = pieces.select{ |p| p if p.type == "Rook" }
      left_rook = rooks.select{ |r| r if r.position == "a8" || r.position == "a1" }[0]
      left_to   =  
      right_rook = rooks.select{ |r| r if r.position == "h8" || r.position == "h1" }[0]
      rooks.each { |rook| rooks.delete(rook) if rook.has_moved }

      if king.color == "white"
        left_side  = board.keys.select{ |t| board[t] if t == :d1 || t == :c1 || t == :b1 }
        left_to    = :c1    
        right_side = board.keys.select{ |t| board[t] if t == :f1 || t == :g1 }
        right_to   = :g1    
      else 
        left_side = board.keys.select{ |t| board[t] if t == :d8 || t == :c8 || t == :b8 }
        left_to    = :c8    
        right_side = board.keys.select{ |t| board[t] if t == :f8 || t == :g8 }  
        right_to   = :g8    
      end

      case
      when king.has_moved || rooks.length == 0
        return {}
      when left_side.any?{ |t| board[t] != "" } && right_side.any?{ |t| board[t] != "" }
        return {}
      when rooks.length
        if left_side.all?{ |t| board[t] == "" } && !left_rook.has_moved
          castleable[king.name].merge!( { left_to.to_s => ["castling"] } )
        end
        if right_side.all?{ |t| board[t] == "" } && !right_rook.has_moved
          castleable[king.name].merge!( { right_to.to_s => ["castling"] } )
        end
      else
        return {}
      end

      if castleable.empty? || castleable.nil? || castleable[king.name].empty?
        return {}
      else
        return castleable
      end
    end # end castle_moves
        
    private 

      def fill_row(num, board)
        letters=("a".."h").to_a
        letters.each do |letter|
          board[(letter + num.to_s).to_sym] = ""
        end
      end

  end

end