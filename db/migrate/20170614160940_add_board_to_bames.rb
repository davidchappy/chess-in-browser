class AddBoardToBames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :board, :string
  end
end
