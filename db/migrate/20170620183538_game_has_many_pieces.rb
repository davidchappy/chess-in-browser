class GameHasManyPieces < ActiveRecord::Migration[5.1]
  def change
    remove_column :games, :status, :string
    add_column    :games, :status, :string, default: "starting"
    remove_column :pieces, :player_id, :bigint
    remove_column :pieces, :player_type, :string
    add_column    :pieces, :game_id, :bigint
    add_column    :moves, :from, :string
  end
end
