class AddOriginalDatetimeToImages < ActiveRecord::Migration
  def change
    add_column :images, :original_datetime, :datetime
  end
end
