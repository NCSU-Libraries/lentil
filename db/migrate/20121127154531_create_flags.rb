class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.references :image

      t.timestamps
    end
    add_index :flags, :image_id
  end
end
