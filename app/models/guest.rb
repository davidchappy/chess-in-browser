class Guest < ApplicationRecord
  include PieceMethods

  has_one :game, as: :white, dependent: :destroy
  has_one :game, as: :black, dependent: :destroy
  has_many :pieces, as: :player, dependent: :destroy
  validates_presence_of :name
end
