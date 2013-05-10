require 'test_helper'

class ThisorthatTest < ActionDispatch::IntegrationTest

  test "should be able to pick winners" do
    VCR.use_cassette('battle_images') do
      visit(lentil.thisorthat_battle_path)

      battle_images = all('form .battle-image-wrap')
      assert_equal(2, battle_images.length)

      buttons = all('.btn-large.battle-form')
      images_ids = buttons.map{|btn| btn[:value]}
      buttons.first.click

      # check for the presence of the results
      assert page.has_selector?("#image_#{images_ids.first}")
      assert page.has_selector?("#image_#{images_ids.last}")

      # check that there are again two images entered into battle
      battle_images = all('form .battle-image-wrap')
      assert_equal(2, battle_images.length)
    end
  end

  test "should see an error message when no images are present" do
    Lentil::Image.all.each{|image| image.destroy}
    visit(lentil.thisorthat_battle_path)
    assert page.has_content?('Error')
    assert page.has_content?('If the problem persists, please e-mail')
  end

end
