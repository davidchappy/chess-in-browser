module Chess  

  class Piece

    class Queen < Piece

      def moves(piece, game)
        offsets = [-9,-8,-7,-1,1,7,8,9]
        queen_moves = generate_paths_for(offsets, piece, game)
      end

    end
    
  end

end