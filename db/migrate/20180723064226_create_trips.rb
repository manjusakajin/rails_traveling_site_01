class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.string :name
      t.string :slug, unique: true
      t.string :begin
      t.integer :destination_id
      t.integer :user_id
      t.text :plan
      t.text :expense

      t.timestamps
    end
  end
end
