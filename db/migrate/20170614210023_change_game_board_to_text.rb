class ChangeGameBoardToText < ActiveRecord::Migration[5.1]
  def change
    change_column :games, :board, :text
  end
end
