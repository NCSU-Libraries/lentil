class AddLongUrlToImages < ActiveRecord::Migration
  def change
    add_column :images, :long_url, :string
  end
end
