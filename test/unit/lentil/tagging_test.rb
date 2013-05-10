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

require 'test_helper'

class TaggingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
