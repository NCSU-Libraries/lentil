require 'test_helper'

class EventTrackingTest < ActionDispatch::IntegrationTest

  setup do
  	browser_start
    @image = lentil_images(:one)
  end
  teardown do
  	browser_end
  end

  test "should trigger an event for clicking on an image" do
  	visit(lentil.images_path)
    find("#image_#{@image.id} a.fancybox").click
    assert_equal("_trackEvent,image,click,image_#{@image.id}", console_message)
  end

  test "should trigger an event for clicking on the share button" do
    visit(lentil.image_path(@image))
    find('.share').click
    assert_equal("_trackEvent,image_view,share,#{@image.id}", console_message)
  end

  test "should trigger an event for clicking on the facebook share link" do
    visit(lentil.image_path(@image))
    find('.facebook').click
    assert_equal("_trackEvent,image_view,facebook,#{@image.id}", console_message)
  end

  test "should trigger an event for clicking on the twitter share link" do
    visit(lentil.image_path(@image))
    find('.twitter').click
    assert_equal("_trackEvent,image_view,twitter,#{@image.id}", console_message)
  end

  # FIXME: This fails for an unknown reason.
  # test "should trigger an event for clicking on the email share link" do
  #   visit(lentil.image_path(@image))
  #   find('.email').click
  #   assert_equal("_trackEvent,image_view,email,#{@image.id}", console_message)
  # end

  test "should trigger an event for liking and unliking an image" do
    visit lentil.image_path(@image)
    find('.like-btn.initial-state', :visible => true).click
    assert_equal("_trackEvent,image_view,like,#{@image.id}", console_message)
    find('.like-btn.already-clicked', :visible => true).click
    assert_equal("_trackEvent,image_view,unlike,#{@image.id}", console_message)
  end

  test "should trigger an event for unliking an image that was previously liked" do
    visit lentil.image_path(@image)
    find('.like-btn.initial-state').click
    visit lentil.images_path
    visit lentil.image_path(@image)
    find('.like-btn.already-clicked').click
    assert_equal("_trackEvent,image_view,unlike,#{@image.id}", console_message)
  end

  test "clicking the flag button" do
    visit lentil.image_path(@image)
    find('.flag-btn', :visible => true).click
    assert_equal("_trackEvent,image_view,flag,#{@image.id}", console_message)
  end

end
