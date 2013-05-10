class AddServiceIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :service_id, :integer
  end
end
