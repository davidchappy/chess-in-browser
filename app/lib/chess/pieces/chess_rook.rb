module Chess  

  class Piece

    class Rook < Piece

      def moves(piece, game)
        offsets = [-8,-1,1,8]
        rook_moves = generate_paths_for(offsets, piece, game)
      end

    end

  end

end