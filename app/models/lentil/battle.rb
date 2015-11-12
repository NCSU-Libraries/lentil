# == Schema Information
#
# Table name: lentil_battles
#
#  id         :integer          not null, primary key
#  image_id   :integer
#  loser_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Lentil::Battle < ActiveRecord::Base
  belongs_to :image, :counter_cache => :wins_count, :autosave => true
  belongs_to :loser, :class_name => "Image", :counter_cache => :losses_count, :autosave => true

  after_commit :update_win_pct

  protected
  def update_win_pct
    self.image.reload
    self.loser.reload

    winner_pct = (self.image.wins_count.to_f / (self.image.wins_count + self.image.losses_count).to_f * 100).round
    self.image.win_pct = winner_pct
    self.image.save

    loser_pct = (self.loser.wins_count.to_f / (self.loser.wins_count + self.loser.losses_count).to_f * 100).round
    self.loser.win_pct = loser_pct
    self.loser.save
  end
end
