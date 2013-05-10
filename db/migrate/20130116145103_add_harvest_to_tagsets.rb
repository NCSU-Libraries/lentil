class AddHarvestToTagsets < ActiveRecord::Migration
  def change
    add_column :tagsets, :harvest, :boolean, :default => false
  end
end
