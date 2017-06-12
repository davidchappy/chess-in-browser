class AddPlayerTypeToPieces < ActiveRecord::Migration[5.1]
  def change
    add_column :pieces, :player_type, :string
  end
end
