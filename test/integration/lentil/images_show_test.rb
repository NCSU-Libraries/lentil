require 'test_helper'

class ImagesShowIndexTest < ActionDispatch::IntegrationTest

  # This is important otherwise there is some strange reloading that goes on
  test "should have a class on the body" do
    visit(lentil.image_path lentil_images(:one))
    assert page.has_selector?('body.lentil-images_show')
  end
	
  test "video should have a video tag" do
    visit(lentil.image_path lentil_images(:video))
    assert page.has_selector?('video')
  end

end
