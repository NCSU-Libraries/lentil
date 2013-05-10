class CreateTagsets < ActiveRecord::Migration
  def change
    create_table :tagsets do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
