class AddFileHarvestedDateFieldToImages < ActiveRecord::Migration
  def change
    add_column :images, :file_harvested_date, :datetime
    add_column :images, :file_harvest_failed, :integer, :default => 0
  end
end
