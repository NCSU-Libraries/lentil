class CreateLicensings < ActiveRecord::Migration
  def change
    create_table :licensings do |t|
      t.references :image
      t.references :license

      t.timestamps
    end
    add_index :licensings, :image_id
    add_index :licensings, :license_id
  end
end
