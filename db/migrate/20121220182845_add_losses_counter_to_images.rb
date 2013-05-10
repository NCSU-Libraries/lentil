class AddLossesCounterToImages < ActiveRecord::Migration
  def change
    add_column :images, :losses_count, :integer, :default => 0
  end
end
