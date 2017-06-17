class Game < ApplicationRecord
  include PieceMethods
  include GamePrep
  include GameUpdate

  after_create :start_game
  serialize :board

  # Associations
  belongs_to :white, polymorphic: true
  belongs_to :black, polymorphic: true

  # Validations
  validates_inclusion_of :status,
    in: ["starting", "saved", "playing", "check", "check_mate"]
  validates_inclusion_of :black_type, in: ["Guest", "User"]
  validates_inclusion_of :white_type, in: ["Guest", "User"]

  def self.start(white, black)
    game = Game.create!(white: white, black: black, status: "starting")
    [game, game.white, game.black]
  end

  def update(move)
    game = Chess::Game.process_move(self.board, move)
    game.white.save!
    game.black.save!
    game.save!

    # update game.white.pieces with move
    # update game.black.pieces with move
    # switch turn
    [game, game.white, game.black]
  end

  private

    def start_game
      # game_prep
      generate_pieces(self)
      position_pieces(self)
      init_board(self)
      # game_update
      get_moves(self)
      set_status(self, "playing")
      set_turn(self.white, self.black)
    end

end
