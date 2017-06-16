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

  end

end