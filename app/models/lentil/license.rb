# == Schema Information
#
# Table name: lentil_licenses
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  url         :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  short_name  :string(255)
#

class Lentil::License < ActiveRecord::Base
  has_many :licensings
  has_many :images, :through=>:licensings

  validates_uniqueness_of :short_name
end
