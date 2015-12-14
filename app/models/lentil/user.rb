# == Schema Information
#
# Table name: lentil_users
#
#  id           :integer          not null, primary key
#  user_name    :string(255)
#  full_name    :string(255)
#  banned       :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  service_id   :integer
#  bio          :text
#  images_count :integer          default(0)
#

class Lentil::User < ActiveRecord::Base
  attr_accessible :banned, :full_name, :user_name, :bio

  stores_emoji_characters :full_name, :bio

  has_many :images
  belongs_to :service

  validates_uniqueness_of :user_name, :scope => :service_id

  def number_of_images
    self.images.count
  end
end
