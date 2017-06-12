module Chess

  class Game
    include PieceMethods

    def self.start(game)
      chess = self.new
      starting_positions = chess.starting_positions(game)
      chess.place_pieces(game, starting_positions)
      game
    end

    # def self.update(game, positions)
    #   chess_game = self.new
    #   chess_game.place_pieces(game, positions)
    # end

    def place_pieces(game, positions)
      [game.white.pieces, game.black.pieces].each do |color|
        color.each do |piece|
          piece.position = positions[piece.id] if positions.keys.include?(piece.id)
          piece.save!
        end
      end
    end

    def starting_positions(game)
      positions = {}

      white_positions = Piece.positions[:white]
      mapped_white = map_piece_positions(game.white.pieces, white_positions)
      positions.merge!(mapped_white)

      black_positions = Piece.positions[:black]
      positions.merge!(map_piece_positions(game.black.pieces, black_positions))

      positions
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

  class Piece

    def self.positions
      {
        white: {
          rooks: ["a1", "h1"],
          knights: ["b2", "g1"],
          bishops: ["c1", "f1"],
          king: ["e1"],
          queen: ["d1"],
          pawns: ["a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2"],
        },
        black: {
          rooks: ["a8", "h8"],
          knights: ["b8", "g8"],
          bishops: ["c8", "f8"],
          king: ["e8"],
          queen: ["d8"],
          pawns: ["a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7"],
        }
      }
    end

  end

end