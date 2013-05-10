class AddStaffTagToTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :staff_tag, :boolean, :default => false
  end
end
