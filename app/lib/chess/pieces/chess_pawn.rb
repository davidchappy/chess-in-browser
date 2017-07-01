module Chess  

  class Piece

    class Pawn < Piece

      def moves(piece, game)
        possible_moves = {}
        offsets = []
        left = offsets_to_coordinates([-1], piece, game)
        right = offsets_to_coordinates([1], piece, game)

        # allow 2 movements forward at start, diagonal capturing, and en_passant
        if piece.color == "white"
          in_front = offsets_to_coordinates([-8], piece, game)
          two_in_front = offsets_to_coordinates([-16], piece, game)
          front_left = offsets_to_coordinates([-9], piece, game)
          front_right = offsets_to_coordinates([-7], piece, game)
          unless chess_board.is_piece?(in_front, game)
            offsets << -8
            offsets << -16 if piece.position[1] == "2" && !chess_board.is_piece?(two_in_front, game)
          end
          offsets << -9 if !front_left.nil? && chess_board.is_enemy?(front_left, "white", game)
          offsets << -7 if !front_right.nil? && chess_board.is_enemy?(front_right, "white", game)
          if chess_board.en_passant?(piece, game)
            offsets << -9 if !left.nil? && chess_board.is_enemy?(left, "white", game)
            offsets << -7 if !right.nil? && chess_board.is_enemy?(right, "white", game)
          end
        elsif piece.color == "black"
          in_front = offsets_to_coordinates([8], piece, game)
          two_in_front = offsets_to_coordinates([16], piece, game)
          front_left = offsets_to_coordinates([9], piece, game)
          front_right = offsets_to_coordinates([7], piece, game)
          unless chess_board.is_piece?(in_front, game)
            offsets << 8
            offsets << 16 if piece.position[1] == "7" && !chess_board.is_piece?(two_in_front, game)
          end
          offsets << 9 if !front_left.nil? && chess_board.is_enemy?(front_left, "black", game)
          offsets << 7 if !front_right.nil? && chess_board.is_enemy?(front_right, "black", game)
          if chess_board.en_passant?(piece, game)
            offsets << 7 if !left.nil? && chess_board.is_enemy?(left, "black", game)
            offsets << 9 if !right.nil? && chess_board.is_enemy?(right, "black", game)
          end
        end

        legal_moves = offsets_to_coordinates(offsets, piece, game)
        if legal_moves.class == Array
          legal_moves.each { |move| possible_moves[move] = [] unless chess_board.obstructed?(move, piece.color, game) }
        else
          possible_moves[legal_moves] = [] unless chess_board.obstructed?(legal_moves, piece.color, game)
        end
        possible_moves
      end

    end
    

  end

end