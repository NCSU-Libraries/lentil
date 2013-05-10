class CreateLikeVotes < ActiveRecord::Migration
  def change
    create_table :like_votes do |t|
      t.references :image

      t.timestamps
    end
    add_index :like_votes, :image_id
  end
end
