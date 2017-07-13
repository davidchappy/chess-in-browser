class Game < ApplicationRecord
  include GameUtils
  include GamePrep
  include GameUpdate

  serialize :board

  # Associations
  belongs_to :white, polymorphic: true
  belongs_to :black, polymorphic: true
  has_many   :pieces, dependent: :destroy, autosave: true

  accepts_nested_attributes_for :pieces

  # Validations
  validates_inclusion_of :status,
    in: ["starting", "saved", "playing", "check", "check_mate", "promoting"]
  validates_inclusion_of :black_type, in: ["Guest", "User"]
  validates_inclusion_of :white_type, in: ["Guest", "User"]

  def self.start(white, black)
    game = Game.create!(white: white, black: black, status: "starting")
    start_tasks
    # game_state = GameState.create_state(game)??
    game
  end

  def update(move)
    # game_state = GameState.create_state(self)
    # update_tasks(game_state)
    # game_state.update_from_state
    update_tasks(move)
    self
  end

  private

    # The methods below are found in ./concerns
    
    def start_tasks
      # game_prep
      generate_pieces
      generate_board
      # game_update
      # 
      set_turn
      get_moves
      set_status("playing")
    end

    def update_tasks(move)
      # game_update
      update_board(move)
      update_pieces
      set_turn
      get_moves(move)
    end

end
