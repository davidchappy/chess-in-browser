module Chess  

  class Piece

    class Knight < Piece

      def moves(piece, game)
        possible_moves = {}
        offsets = [-17,-15,-10,-6,6,10,15,17]
        moves = offsets_to_coordinates(offsets, piece, game)
        moves.each do |move| 
          if move.nil? || piece.position.nil?
            next
          elsif knight_wrapped?(move, piece.position)
            next
          elsif chess_board.obstructed?(move, piece.color, game)
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

  end

end