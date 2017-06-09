class Player < User
  has_many  :white_games, class_name: "Game", foreign_key: "white_id", dependent: :destroy
  has_many  :black_games, class_name: "Game", foreign_key: "black_id", dependent: :destroy
  has_many  :pieces, dependent: :destroy

  validates :name, presence: true
end
