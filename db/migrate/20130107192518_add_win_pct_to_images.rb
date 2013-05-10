class AddWinPctToImages < ActiveRecord::Migration
  def change
    add_column :images, :win_pct, :float, :default => nil
  end
end
