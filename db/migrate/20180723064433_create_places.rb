class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :name
      t.string :adress
      t.text :description
      t.float :lat
      t.float :lng
      t.boolean :is_deleted
      t.integer :checkin_count, :default => 0

      t.timestamps
    end
  end
end
