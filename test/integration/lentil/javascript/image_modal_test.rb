require 'test_helper'

class ImageModalTest < ActionDispatch::IntegrationTest

  setup do
  	browser_start
  end
  teardown do
  	browser_end
  end

  test "should see a modal when clicking on an image" do
    visit lentil.images_path
    assert page.has_no_content?('six #hunttesting')
    assert page.has_no_selector?('.fancybox-image')
    all('.fancybox').first.click
    assert page.has_content?('six #hunttesting')
    assert page.has_selector?('.fancybox-image')
  end
end
