class CreatePieces < ActiveRecord::Migration[5.1]
  def change
    create_table :pieces do |t|
      t.string  :position
      t.string  :type
      t.belongs_to :player, index: true
      t.belongs_to :game, index: true

      t.timestamps
    end
  end
end
