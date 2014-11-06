class AddTypeToImages < ActiveRecord::Migration
  def change
    add_column :lentil_images, :type, :string
    add_column :lentil_images, :video_url, :string
  end
end
