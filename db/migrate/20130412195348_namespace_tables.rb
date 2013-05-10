class NamespaceTables < ActiveRecord::Migration
  def change
    rename_table :admin_users, :lentil_admin_users
    rename_table :battles, :lentil_battles
    rename_table :flags, :lentil_flags
    rename_table :images, :lentil_images
    rename_table :licenses, :lentil_licenses
    rename_table :like_votes, :lentil_like_votes
    rename_table :services, :lentil_services
    rename_table :taggings, :lentil_taggings
    rename_table :tags, :lentil_tags
    rename_table :tagset_assignments, :lentil_tagset_assignments
    rename_table :tagsets, :lentil_tagsets
    rename_table :users, :lentil_users
  end
end
