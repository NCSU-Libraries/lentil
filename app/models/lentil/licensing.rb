# == Schema Information
#
# Table name: lentil_licensings
#
#  id         :integer          not null, primary key
#  image_id   :integer
#  license_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Lentil::Licensing < ActiveRecord::Base
  belongs_to :image
  belongs_to :license
end
