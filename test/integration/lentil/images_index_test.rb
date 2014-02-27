require 'test_helper'

class ImagesIndexTest < ActionDispatch::IntegrationTest

  setup do
    visit(lentil.images_path)
    image = lentil_images(:one)
    @image_id = "#image_#{image.id}"
  end

  test "should have the content 'Your base app page title' on the index page" do
    assert page.has_content?('Your base app page title')
  end

  test "should have the titles of the images on the index page" do
    assert page.has_content?('six #hunttesting')
  end

  test "should have usernames of image contributors" do
    assert page.has_content?('bd')
  end

  # test "should be able to like vote for an image on the index page and see vote counts" do
  #   assert page.has_selector?("#{@image_id} .like_btn")
  #   assert page.has_selector?("#{@image_id} .like_count", :text => '0 votes')
  #   page.find("#{@image_id} .like_btn").click
  #   assert page.has_selector?("#{@image_id} .like_count", :text => '1 vote')
  # end

  # test "should only be able to like vote for an image one time" do
  #   page.find("#{@image_id} .like_btn").click
  #   assert page.has_selector?("#{@image_id} .like_count", :text => '1 vote')
  #   assert page.has_no_selector?("#{@image_id} .like_btn")
  # end

  test "should be able to flag an image as inappropriate" do
    assert page.has_selector?("#{@image_id} .flag-btn")
  end

  # test "should only be able to flag an image as inappropriate one time" do
  #   page.find("#{@image_id} .initial-state .flag-btn").click
  #   assert page.has_no_selector?("#{@image_id} .initial-state .flag-btn")
  # end

end
