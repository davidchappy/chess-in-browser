class Move < ApplicationRecord
  belongs_to :piece
  serialize :flags
  validates_presence_of :to
end