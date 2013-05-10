class CreateTagsetAssignments < ActiveRecord::Migration
  def change
    create_table :tagset_assignments do |t|
      t.references :tag
      t.references :tagset

      t.timestamps
    end
    add_index :tagset_assignments, :tag_id
    add_index :tagset_assignments, :tagset_id
  end
end
