class GameState < Hash
  # include ActiveModel::Serialization

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
      if piece_hash[:moves].length > 0
        piece_hash[:moves].each_with_index do |move_hash, j|
          move = Move.find(move_hash[:id])
          move_attributes = [:id, :flags, :to, :from]
          update_with_hash(move, move_attributes, state[:pieces][i][:moves][j])
        end
      end
    end
  end

  private

    def update_with_hash(record, attributes, state_hash)
      update_hash = state_hash.select{ |k, v| attributes.include?(k) }
      record.update_attributes(update_hash)
    end

end