class AddPopularScoreToImages < ActiveRecord::Migration
  def change
    add_column :images, :popular_score, :integer, :default => 0
  end
end
