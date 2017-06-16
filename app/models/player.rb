class Player < User
  include PieceMethods

  has_many  :games, as: :white, dependent: :destroy, autosave: true
  has_many  :games, as: :black, dependent: :destroy, autosave: true
  has_many  :pieces, as: :player, dependent: :destroy, autosave: true

  validates :name, presence: true
end
