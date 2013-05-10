class AddExternalIdentifierToImages < ActiveRecord::Migration
  def change
    add_column :images, :external_identifier, :string
    add_index :images, :external_identifier
  end
end
