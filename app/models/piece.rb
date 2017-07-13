class Piece < ApplicationRecord
  belongs_to :game
  has_many   :moves, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :moves

  validates_presence_of :position
  validates_inclusion_of :type, in: ["King", "Queen", "Bishop", "Knight", "Rook", "Pawn"]

  # https://github.com/rails/rails/issues/3508
  def serializable_hash(options = nil)
    super.merge "type" => type
  end

end
