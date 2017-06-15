class Game < ApplicationRecord
  include GamePrep
  include PieceMethods
  include Turns
  after_create :generate
  # after_update :update
  serialize :board

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
    [game, game.white, game.black]
  end

  def self.update(game, move)
    game = Chess::Game.update(game.board, move).save!
    # update game.white.pieces with move
    # update game.black.pieces with move
    # switch turn
    [game, game.white, game.black]
  end

  private

    def generate
      generate_pieces(self)
      place_pieces(self)
      fill_board(self)
      set_status(self, "playing")
      set_turn(self.white, self.black)
    end

    def update
      Chess::Game.test("Hello from Chess::Game")
    end

end
