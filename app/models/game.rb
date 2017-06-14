class Game < ApplicationRecord
  include GamePrep
  include PieceMethods
  after_create :generate

  # Associations
  belongs_to :white, polymorphic: true
  belongs_to :black, polymorphic: true
  has_many   :pieces, dependent: :destroy

  # Validations
  validates_inclusion_of :status,
    in: ["starting", "saved", "playing", "check", "check_mate"]
  validates_inclusion_of :black_type, in: ["Guest", "User"]
  validates_inclusion_of :white_type, in: ["Guest", "User"]

  def self.start(white, black)
    game = Game.create!(white: white, black: black, status: "starting")
    
    Chess::Game.place_pieces(game.white.pieces, :white).each(&:save!)
    Chess::Game.place_pieces(game.black.pieces, :black).each(&:save!)

    [game, game.white, game.black]
  end

  private 

    def generate
      generate_pieces(self)
    end
end
