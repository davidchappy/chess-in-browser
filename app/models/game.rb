class Game < ApplicationRecord
  include GameUtils
  include GamePrep
  include GameUpdate

  after_create :start_tasks
  serialize :board

  # Associations
  belongs_to :white, polymorphic: true
  belongs_to :black, polymorphic: true
  has_many   :pieces, dependent: :destroy, autosave: true


  # Validations
  validates_inclusion_of :status,
    in: ["starting", "saved", "playing", "check", "check_mate", "promoting"]
  validates_inclusion_of :black_type, in: ["Guest", "User"]
  validates_inclusion_of :white_type, in: ["Guest", "User"]

  def self.start(white, black)
    game = Game.create!(white: white, black: black, status: "starting")
    game
  end

  def update(move)
    update_tasks(move)
    self
  end

  private

    # The methods below are found in ./concerns
    
    def start_tasks
      # game_prep
      game = generate_pieces(self).save!
      position_pieces(self)
      init_board(self)
      # game_update
      set_turn
      get_moves(self)
      set_status("playing")
    end

    def update_tasks(move)
      update_board(self, move)
      update_pieces(self)
      set_turn
      get_moves(self, move)
    end

end
