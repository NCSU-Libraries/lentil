# == Schema Information
#
# Table name: lentil_taggings
#
#  id         :integer          not null, primary key
#  image_id   :integer
#  tag_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  staff_tag  :boolean          default(FALSE)
#

class Lentil::Tagging < ActiveRecord::Base
  belongs_to :image
  belongs_to :tag

  attr_accessible :tag, :staff_tag, :tag_id

  validates :image_id, :uniqueness => {:scope => :tag_id}
end
