class Move < ApplicationRecord
  belongs_to :piece
  serialize :flags, Array
  validates_presence_of :to
end