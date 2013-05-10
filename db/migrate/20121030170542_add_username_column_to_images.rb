class AddUsernameColumnToImages < ActiveRecord::Migration
  def change
    add_column :images, :username, :string
  end
end
