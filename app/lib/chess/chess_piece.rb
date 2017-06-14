module Chess  

  class Piece
    def self.positions
    # Hash of starting piece positions by color
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