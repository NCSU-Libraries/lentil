class AddImagesCountToUsers < ActiveRecord::Migration
   def self.up
    add_column :users, :images_count, :integer, :default => 0

    # User.reset_column_information
    # User.all.each do |u|
    #   u.update_attribute :images_count, u.images.length
    # end
  end

  def self.down
    remove_column :users, :images_count
  end
end
