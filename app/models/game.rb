class Game < ApplicationRecord
  belongs_to :white_player, class_name: "Player", foreign_key: "white_id"
  belongs_to :black_player, class_name: "Player", foreign_key: "black_id"
  has_many   :pieces, dependent: :destroy

  validates_inclusion_of :status,
    in: ["saved", "playing", "check", "check_mate"]
end
