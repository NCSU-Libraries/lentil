class AddTypeToImages < ActiveRecord::Migration
  def change
    add_column :lentil_images, :media_type, :string
    add_column :lentil_images, :video_url, :string
  end
end
