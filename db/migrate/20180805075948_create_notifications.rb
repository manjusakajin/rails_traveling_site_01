class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :trip_id
      t.string :event

      t.timestamps
    end
  end
end
