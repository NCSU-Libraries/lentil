class AddDefaultForStaffLike < ActiveRecord::Migration
  def change
    change_column :images, :staff_like, :boolean, :default => false
  end
end
