module Chess  

  class Piece

    class Bishop < Piece

      def moves(piece, game)
        offsets = [-9,-7,7,9]
        bishop_moves = generate_paths_for(offsets, piece, game)
      end

    end

  end

end