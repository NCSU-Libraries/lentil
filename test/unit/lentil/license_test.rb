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

require 'test_helper'

class LicenseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
