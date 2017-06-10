class CreateGuests < ActiveRecord::Migration[5.1]
  def change
    create_table :guests do |t|
      t.string :name
      t.boolean :is_playing, default: false

      t.timestamps
    end
  end
end
