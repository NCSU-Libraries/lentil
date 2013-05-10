class AddWinsCounterToImages < ActiveRecord::Migration
  def change
    add_column :images, :wins_count, :integer, :default => 0
  end
end
