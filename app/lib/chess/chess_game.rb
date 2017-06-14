module Chess

  class Game
    include PieceMethods

    def self.update(game, positions)
      chess_game = self.new
      chess_game.place_pieces(game, positions)
    end

    def self.place_pieces(pieces, color)
      # assign starting positions to each piece in array for given color
      positions = starting_positions(pieces, color)
      pieces.each do |piece|
        piece.position = positions[piece.id] if positions.keys.include?(piece.id)
      end
      pieces
    end

    # Private
    
    class << self
    
      def starting_positions(pieces, color)
        positions = Piece.positions[color]
        return map_piece_positions(pieces, positions)
      end   

      def map_piece_positions(pieces, positions)
        mapped_positions = {}
        pieces.map do |piece|
          position = ""
          case piece.type
          when "Rook"
            position = positions[:rooks].delete_at(0)
          when "Knight"
            position = positions[:knights].delete_at(0)
          when "Bishop"
            position = positions[:bishops].delete_at(0)
          when "King"
            position = positions[:king].delete_at(0)
          when "Queen"
            position = positions[:queen].delete_at(0)
          when "Pawn"
            position = positions[:pawns].delete_at(0)
          end
          mapped_positions[piece.id] = position
        end
        mapped_positions
      end

    end
  end

end