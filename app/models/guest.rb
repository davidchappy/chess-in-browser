class Guest < ApplicationRecord
  has_one :game, as: :white, dependent: :destroy
  has_one :game, as: :black, dependent: :destroy
  has_many :pieces, class_name: "Piece", foreign_key: "player_id", dependent: :destroy
  validates_inclusion_of :name, in: ["white", "black"]
end
