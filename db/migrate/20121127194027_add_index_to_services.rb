class AddIndexToServices < ActiveRecord::Migration
  def change
    add_index :services, :name
  end
end
