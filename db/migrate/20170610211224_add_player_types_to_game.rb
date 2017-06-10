class AddPlayerTypesToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :black_type, :string
    add_column :games, :white_type, :string
  end
end
