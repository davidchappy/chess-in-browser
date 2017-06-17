class Piece < ApplicationRecord
  belongs_to :player, polymorphic: true
  has_many   :moves, dependent: :destroy, autosave: true

  validates_presence_of :position
  validates_inclusion_of :type, in: ["King", "Queen", "Bishop", "Knight", "Rook", "Pawn"]
end
