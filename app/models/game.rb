class Game < ApplicationRecord
  belongs_to :white, polymorphic: true
  belongs_to :black, polymorphic: true
  has_many   :pieces, dependent: :destroy

  validates_inclusion_of :status,
    in: ["starting", "saved", "playing", "check", "check_mate"]

  validates_inclusion_of :black_type, in: ["Guest", "User"]
  validates_inclusion_of :white_type, in: ["Guest", "User"]
end
