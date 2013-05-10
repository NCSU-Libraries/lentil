class AddUrlColumnToImages < ActiveRecord::Migration
  def change
    add_column :images, :url, :string
  end
end
