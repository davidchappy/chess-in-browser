module Chess

  class Board

    def valid_tile?(coordinate, board)
      return true if !coordinate.nil? && board.keys.include?(coordinate.to_sym)
      false
    end

    def is_piece?(coordinate, board)
      classes = [Piece, Rook, Bishop, Knight, King, Queen, Pawn]
      return true if !coordinate.nil? && classes.include?(board[coordinate.to_sym].class)
      false
    end

    def open_tile?(coordinate, board)
      return true if valid_tile?(coordinate, board) && !is_piece?(coordinate, board)
      false
    end

    def is_enemy?(coordinate, player_color, board)
      return true if is_piece?(coordinate, board) && player_color != board[coordinate.to_sym].color
      false
    end

    def obstructed?(coordinate, player_color, board)
      return true if is_piece?(coordinate, board) && !is_enemy?(coordinate, player_color, board)
      false
    end

    def en_passant?(pawn, board)
      if pawn.type == "Pawn"
        col_as_num = pawn.position[0].ord
        row = pawn.position[1]
        right_position = "#{(col_as_num+1).chr}#{row}"
        left_position = "#{(col_as_num-1).chr}#{row}"
        if pawn.color == "white" && row == "5"
          return true if !board[right_position.to_sym].nil? && is_enemy?(right_position, pawn.color, board) 
          return true if !board[left_position.to_sym].nil? && is_enemy?(left_position, pawn.color, board) 
        elsif pawn.color == "black" && row == "4"
          return true if !board[right_position.to_sym].nil? && is_enemy?(right_position, pawn.color, board) 
          return true if !board[left_position.to_sym].nil? && is_enemy?(left_position, pawn.color, board) 
        end
      end
      false
    end

    def castle_moves(game)
      castleable = {}
      board = game.board
      player = game.current_player
      pieces = player.pieces
      king = pieces.select{ |p| p if p.type == "King" }[0]
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
          castleable[king.name].merge!( { left_to.to_s => "castling" } )
        end
        if right_side.all?{ |t| board[t] == "" } && !right_rook.has_moved
          castleable[king.name].merge!( { right_to.to_s => "castling" } )
        end
      else
        return {}
      end

      if castleable.empty? || castleable.nil? || castleable[king.name].empty?
        return {}
      else
        return castleable
      end
    end

  end

end