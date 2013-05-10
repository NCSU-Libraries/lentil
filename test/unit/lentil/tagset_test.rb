# == Schema Information
#
# Table name: lentil_tagsets
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  harvest     :boolean          default(FALSE)
#

require 'test_helper'

class TagsetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Tagset should have a tag" do
    assert_equal lentil_tags(:one).name, lentil_tagsets(:one).tags.first.name
  end
end
