require 'test_helper'

class AdminImagesControllerTest < ActionController::TestCase

  setup do
    @controller = ::Admin::LentilImagesController.new
    user = lentil_admin_users(:one)
    sign_in user
  end

  test "should get to images index" do
    get :index, :use_route => :lentil
    assert_response :success
  end

  test "should get show view" do
    get :show, {:id => lentil_images(:one).id, :use_route => :lentil} #admin_lentil_image_path(lentil_images(:one)), :use_route => :lentil
    assert_response :success
  end

  test "should get to images moderate new" do
    get :moderate, :use_route => :lentil
    assert_response :success
  end

  test "should get to images moderate skipped" do
    get :moderate_skipped, :use_route => :lentil
    assert_response :success
  end

  test "should get to moderate flagged" do
    get :moderate_flagged, :use_route => :lentil
    assert_response :success
  end

  test "should get flagging history" do
    get :flagging_history, :use_route => :lentil
    assert_response :success
  end

  test "should get to manual images input" do
    get :manual_input, :use_route => :lentil
    assert_response :success
  end

end