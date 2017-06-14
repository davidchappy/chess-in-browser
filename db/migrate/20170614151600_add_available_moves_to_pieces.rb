class AddAvailableMovesToPieces < ActiveRecord::Migration[5.1]
  def change
    add_column :pieces, :available_moves, :string
  end
end
