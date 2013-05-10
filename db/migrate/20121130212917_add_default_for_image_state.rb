class AddDefaultForImageState < ActiveRecord::Migration
  def change
    change_column :images, :state, :integer, :default => 0
  end
end
