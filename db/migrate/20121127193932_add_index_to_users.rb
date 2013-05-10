class AddIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :user_name
  end
end
