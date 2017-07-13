class GameState
  attr_accessor :state

  def self.create_state(game_object)
    state = JSON.parse(game_object.to_json(include: [ { pieces: { include: :moves } }, :white, :black ]))
    GameState.new(state.deep_symbolize_keys)
  end

  def initialize(state)
    @state = state
  end

  def update_from_state
    # Update Game record from hash values
    game = Game.find(state[:id])
    game_attributes = [:id, :status, :time_elapsed, :board]
    update_with_hash(game, game_attributes, state)

    # Update Black player's record from hash values
    black_type = game.black_type.constantize
    black_attributes = [:id, :is_playing]
    black = black_type.find(game.black.id)
    update_with_hash(black, black_attributes, state[:black])
    
    # Update White player's record from hash values
    white_type = game.white_type.constantize
    white_attributes = [:id, :is_playing]
    white = white_type.find(game.white.id)
    update_with_hash(white, white_attributes, state[:white])

    # Update each piece and nested moves from hash values
    pieces = game.pieces
    state[:pieces].each_with_index do |piece_hash, i|
      piece = pieces.find(piece_hash[:id])
      piece_attributes = [:id, :position, :name, :color, :has_moved, :type]
      update_with_hash(piece, piece_attributes, state[:pieces][i])
      
      piece.moves.destroy_all if piece.moves.length > 0
      if piece_hash[:moves].length > 0
        piece_hash[:moves].each_with_index do |move_hash, j|
          piece.moves.create(state[:pieces][i][:moves][j])
        end
      end
    end
  end

  def current_player
    state[:white][:is_playing] ? state[:white] : state[:black]
  end

  def current_pieces
    current_player == state[:white] ? white_pieces : black_pieces
  end

  def other_pieces
    current_player == state[:white] ? black_pieces : white_pieces
  end

  def current_color
    current_player == state[:white] ? 'white' : 'black'
  end

  def other_color
    current_player == state[:white] ? 'black' : 'white'
  end

  def white_pieces
    state[:pieces].select{|piece| piece[:color] == 'white'}
  end

  def black_pieces
    state[:pieces].select{|piece| piece[:color] == 'black'}
  end

  def white_king
    state[:pieces].select{|piece| piece[:name] == 'white-k'}.first
  end

  def black_king
    state[:pieces].select{|piece| piece[:name] == 'black-k'}.first
  end

  def current_king
    state[:pieces].select{|piece| piece[:type] == 'King' && piece[:color] == current_color}.first
  end

  def find_on_board(coordinate)
    if coordinate && coordinate != ""
      target = state[:board][coordinate.to_sym]
    end
    if target == "" || target.nil?
      return ""
    else 
      return find_piece_by_id(target.to_i)
    end
  end

  def position_by_id(piece_id)
    state[:board].select{|t, val| val.to_i == piece_id}.keys[0].to_s
  end

  def find_piece_by_name(name)
    state[:pieces].select{ |piece| piece[:name] == name}.first
  end

  def find_piece_by_id(id)
    state[:pieces].select{|piece| piece[:id] == id}.first
  end

  private

    def update_with_hash(record, attributes, state_hash)
      update_hash = state_hash.select{ |k, v| attributes.include?(k) }
      record.update_attributes(update_hash)
    end

end