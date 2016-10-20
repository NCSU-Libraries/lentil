# == Schema Information
#
# Table name: lentil_flags
#
#  id         :integer          not null, primary key
#  image_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Lentil::Flag < ActiveRecord::Base
  belongs_to :image
end
