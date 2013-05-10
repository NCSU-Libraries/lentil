class AddSecondModerationBooleanToImages < ActiveRecord::Migration
  def change
    add_column :images, :second_moderation, :boolean, :default => false
  end
end
