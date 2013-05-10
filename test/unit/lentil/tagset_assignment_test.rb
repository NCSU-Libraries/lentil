# == Schema Information
#
# Table name: lentil_tagset_assignments
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  tagset_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class TagsetAssignmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
