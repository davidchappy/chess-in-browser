class AddFieldsToPieces < ActiveRecord::Migration[5.1]
  def change
    add_column :pieces, :name, :string
    add_column :pieces, :color, :string
  end
end
