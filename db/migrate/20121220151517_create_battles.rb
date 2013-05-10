class CreateBattles < ActiveRecord::Migration
  def change
    create_table :battles do |t|
      t.integer :image_id
      t.integer :loser_id

      t.timestamps
    end
  end
end
