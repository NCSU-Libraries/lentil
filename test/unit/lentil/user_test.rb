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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "username should be unique for a given service" do
    user = lentil_users(:jr)

    assert !user.service.users.build(:user_name => user.user_name).valid?,
      "username and service should collectively unique"
    assert lentil_services(:flickr).users.build(:user_name => user.user_name).valid?,
      "duplicate usernames are allowed if they are associated with different services"
  end

  test "should have number of associated images" do
    user = lentil_users(:jr)
    assert user.respond_to?(:number_of_images)
    assert user.number_of_images.is_a? Integer
  end
end
