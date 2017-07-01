module Chess  

  class Piece

    class King < Piece

      def moves(piece, game)
        possible_moves = {}
        offsets = [-9,-8,-7,-1,1,7,8,9]
        legal_moves = offsets_to_coordinates(offsets, piece, game)
        puts 'legal_moves for king'
        p legal_moves
        legal_moves.each do |move| 
          unless chess_board.obstructed?(move, piece.color, game) || move.nil?
            possible_moves[move] = [] 
          end
        end
        possible_moves
      end

    end

  end

end
