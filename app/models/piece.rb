class Piece < ApplicationRecord
  belongs_to :game
  belongs_to :player

  validates_presence_of :position
  validates_inclusion_of :type, in: ["King", "Queen", "Bishop", "Knight", "Rook", "Pawn"]
end