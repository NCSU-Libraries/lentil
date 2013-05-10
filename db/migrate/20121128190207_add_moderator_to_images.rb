class AddModeratorToImages < ActiveRecord::Migration
  def change
    add_column :images, :moderator_id, :integer
    add_column :images, :moderated_at, :datetime
    add_index(:images, :moderator_id)
  end
end
