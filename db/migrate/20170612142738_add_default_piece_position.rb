class AddDefaultPiecePosition < ActiveRecord::Migration[5.1]
  def change
    change_column :pieces, :position, :string, default: "unplaced"
  end
end
