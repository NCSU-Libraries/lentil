class AddOriginalMetadataToImages < ActiveRecord::Migration
  def change
    add_column :images, :original_metadata, :text
  end
end
