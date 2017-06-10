class Player < User
  has_many  :games, as: :white, dependent: :destroy
  has_many  :games, as: :black, dependent: :destroy
  has_many  :pieces, dependent: :destroy

  validates :name, presence: true
end
