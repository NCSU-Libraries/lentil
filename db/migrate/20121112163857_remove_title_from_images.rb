class RemoveTitleFromImages < ActiveRecord::Migration
  def up
    remove_column :images, :title
  end

  def down
    add_column :images, :title, :string
  end
end
