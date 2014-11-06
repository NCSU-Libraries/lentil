class AddTypeToImages < ActiveRecord::Migration
  def change
    add_column :lentil_images, :type, :string
  end
end
