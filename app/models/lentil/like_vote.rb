# == Schema Information
#
# Table name: lentil_like_votes
#
#  id         :integer          not null, primary key
#  image_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Lentil::LikeVote < ActiveRecord::Base
  belongs_to :image, counter_cache: true
end
