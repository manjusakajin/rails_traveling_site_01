class AddForeignKeyToChatrooms < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :chatrooms, :trips, column: :slug
  end
end
