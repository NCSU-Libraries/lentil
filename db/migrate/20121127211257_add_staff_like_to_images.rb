class AddStaffLikeToImages < ActiveRecord::Migration
  def change
    add_column :images, :staff_like, :boolean
  end
end
