# == Schema Information
#
# Table name: lentil_tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class TagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Tag should have an image" do
    assert lentil_tags(:hunttesting).images.count > 0
  end
  
  test "Hashtags should be stripped" do
    tag = Lentil::Tag.new(name: '#hashtagTest')
    assert_equal "hashtagTest", tag.name
  end
end
