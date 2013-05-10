require 'test_helper'

class ImagesFeedTest < ActionDispatch::IntegrationTest

  test "should get an RSS feed" do
    visit(lentil.images_path :format => :rss)
    assert page.has_content?('Description of this feed')
  end

  test "should get an Atom feed" do
    visit(lentil.images_path :format => :atom)
    assert page.has_content?('Description of this feed')
  end
end