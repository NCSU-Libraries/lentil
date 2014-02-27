require 'test_helper'

class EventTrackingBattleTest < ActionDispatch::IntegrationTest
  test "battle pick image" do
    VCR.use_cassette('battle_images_events') do
      browser_start
      Lentil::ThisorthatController.any_instance.stubs(:get_images).returns([lentil_images(:dos), lentil_images(:one)])
      visit lentil.thisorthat_battle_path
      first_image = all('.battle-form').first()
      image_id = first_image['value']
      first_image.click
      assert_equal("_trackEvent,battle_view,pick,#{image_id}", console_message)
      find('.battle-result-arrow-wrap') # this should wait for the ajax to finish
      browser_end
    end
  end
 end