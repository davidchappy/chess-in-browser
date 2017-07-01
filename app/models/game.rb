class Game < ApplicationRecord
  include PieceMethods
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

  def current_player
    self.white.is_playing ? self.white : self.black
  end

  def current_pieces
    self.current_player == self.white ? self.white_pieces : self.black_pieces
  end

  def white_pieces
    self.pieces.where(color: "white")
  end

  def black_pieces
    self.pieces.where(color: "black")
  end

  def find_on_board(coordinate)
    target = self.board[coordinate.to_sym]
    if target == "" || target.nil?
      return ""
    else 
      return self.pieces.find(target.to_i)
    end
  end

  def position_by_id(piece_id)
    board.select{|t, val| val == piece_id.to_i}.keys[0].to_s
  end

  private

    # The methods below are found in ./concerns
    
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
