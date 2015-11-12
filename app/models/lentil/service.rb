# == Schema Information
#
# Table name: lentil_services
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  url        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Lentil::Service < ActiveRecord::Base
  has_many :users
  has_many :images, :through => :users
end
