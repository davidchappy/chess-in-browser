class AddHasMovedToPieces < ActiveRecord::Migration[5.1]
  def change
    add_column :pieces, :has_moved, :boolean, default: false
  end
end