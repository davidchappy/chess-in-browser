class RemoveGameIdFromPiece < ActiveRecord::Migration[5.1]
  def change
    remove_column :pieces, :game_id, :integer
  end
end
