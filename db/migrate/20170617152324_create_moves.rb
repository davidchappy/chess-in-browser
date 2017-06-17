class CreateMoves < ActiveRecord::Migration[5.1]
  def change
    create_table  :moves do |t|
      t.string      :flags
      t.string      :to
      t.belongs_to  :piece, index: true

      t.timestamps
    end

    remove_column :pieces, :available_moves, :string
  end
end
