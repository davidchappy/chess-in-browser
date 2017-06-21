class Guest < ApplicationRecord
  include PieceMethods

  has_one :game, as: :white, dependent: :destroy, autosave: true
  has_one :game, as: :black, dependent: :destroy, autosave: true
  validates_presence_of :name
end
