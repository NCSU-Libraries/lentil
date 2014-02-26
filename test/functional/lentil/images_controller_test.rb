require 'test_helper'

class Lentil::ImagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, :use_route => :lentil
    assert_response :success
    assert assigns(:images)
  end

  test "should get show" do
    get :show, :id => lentil_images(:one).id, :use_route => :lentil
    assert_response :success
  end

  test "should get recent" do
    get :recent, :use_route => :lentil
    assert_response :success
  end

  test "should get popular" do
    get :popular, :use_route => :lentil
    assert_response :success
  end

  test "should get staff picks" do
    get :staff_picks, :use_route => :lentil
    assert_response :success
    assert_equal(lentil_images(:one), assigns(:images).first)
  end

  test "should get rss feed for index" do
    get :index, :use_route => :lentil, :format => :rss
    assert_response :success
  end

  test "should get atom feed for index" do
    get :index, :use_route => :lentil, :format => :atom
    assert_response :success
  end

  test "should get an animated view of all images" do
    get :animate, :use_route => :lentil
    assert_response :success
  end

  test "should get an animated view of staff pick images" do
    get :staff_picks_animate, :use_route => :lentil
    assert_response :success
  end

  test "should get a tiled view for iframe" do
    get :iframe, :use_route => :lentil
    assert_response :success
  end

end
