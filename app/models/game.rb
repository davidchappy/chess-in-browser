class Game < ApplicationRecord
  include PieceMethods
  include GamePrep
  include GameUpdate

  after_create :start_tasks
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
    update_tasks(move)
    [self, self.white, self.black]
  end

  def current_player
    self.white.is_playing ? self.white : self.black
  end

  private

    def start_tasks
      # game_prep
      game = generate_pieces(self).save!
      position_pieces(self)
      init_board(self)
      # game_update
      set_turn(self.white, self.black)
      get_moves(self)
      set_status(self, "playing")
    end

    def update_tasks(move)
      update_board(self, move)
      update_pieces(self)
      set_turn(self.white, self.black)
      get_moves(self)
    end

end
