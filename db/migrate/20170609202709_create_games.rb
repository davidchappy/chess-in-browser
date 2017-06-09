class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.time :time_elapsed
      t.string :status
      t.integer :white_id
      t.integer :black_id

      t.timestamps
    end
  end
end
