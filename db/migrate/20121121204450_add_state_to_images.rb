class AddStateToImages < ActiveRecord::Migration
  def change
    add_column :images, :state, :integer
  end
end
