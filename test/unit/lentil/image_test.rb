# encoding: utf-8

# == Schema Information
#
# Table name: lentil_images
#
#  id                             :integer          not null, primary key
#  description                    :text
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  like_votes_count               :integer          default(0)
#  url                            :string(255)
#  user_id                        :integer
#  state                          :integer          default(0)
#  external_identifier            :string(255)
#  long_url                       :string(255)
#  original_metadata              :text
#  original_datetime              :datetime
#  staff_like                     :boolean          default(FALSE)
#  moderator_id                   :integer
#  moderated_at                   :datetime
#  second_moderation              :boolean          default(FALSE)
#  wins_count                     :integer          default(0)
#  losses_count                   :integer          default(0)
#  win_pct                        :float
#  popular_score                  :integer          default(0)
#  file_harvested_date            :datetime
#  file_harvest_failed            :integer          default(0)
#  donor_agreement_submitted_date :datetime
#  donor_agreement_failed         :integer          default(0)
#  failed_file_checks             :integer          default(0)
#  file_last_checked              :datetime
#  donor_agreement_rejected       :datetime
#  do_not_request_donation        :boolean
#

require 'test_helper'

class ImageTest < ActiveSupport::TestCase

  test "Image should have tags" do
    image = lentil_images(:one)

    assert image.tags.size > 0, "Expected at least one tag"
  end

  test "Image should have a service tag" do
    image = lentil_images(:one)
    tag = lentil_tags(:hunttesting)
    service_tags = image.service_tags

    assert service_tags.size > 0, "Expected at least one service tag"
    assert_equal tag.name, service_tags.first.name
  end

  test "Image should have a staff tag" do
    image = lentil_images(:one)
    tag = lentil_tags(:hunttesting_staff)
    staff_tags = image.staff_tags

    assert staff_tags.size > 0, "Expected at least one staff tag"
    assert_equal tag.name, staff_tags.first.name
  end

  test "Image should have a license" do
    image = lentil_images(:one)
    license = lentil_licenses(:one)

    assert_equal license.name, image.licenses.first.name
  end

  test "Image description should preserve emoji" do
    image = lentil_images(:one)
    emoji_desc = "Test 😎 emoji"
    image.description = emoji_desc
    image.save
    image.reload
    assert_equal(emoji_desc, image.description)
  end

  test "Image should have valid urls" do
    image = lentil_images(:one)

    invalid_urls = [
      'instagram.com',
      '',
      nil
    ]

    valid_urls = [
      'http://',
      'https://'
    ]

    invalid_urls.each do |new_url|
      image.url = new_url
      assert_equal image.valid?, false
    end

    valid_urls.each do |new_url|
      image.url = new_url
      assert_equal image.valid?, true
    end
  end

  test 'Suppressed images should not be returned with approved images' do
    assert_difference 'Lentil::Image.approved.count', -1,
      'A suppressed image should not be treated as approved' do
      img = Lentil::Image.approved.first
      img.suppressed = true
      img.save
    end
  end
end
