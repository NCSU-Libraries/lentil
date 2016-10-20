require 'test_helper'

class AdminImagesControllerTest < ActionController::TestCase

  setup do
    @controller = ::Admin::LentilImagesController.new
    user = lentil_admin_users(:one)
    sign_in user
  end

  test "should get to images index" do
    get :index
    assert_response :success
  end

  test "should get show view" do
    get :show, {:id => lentil_images(:one).id} #admin_lentil_image_path(lentil_images(:one)), :use_route => :lentil
    assert_response :success
  end

  test "should get to images moderate new" do
    get :moderate
    assert_response :success
  end

  test "should get to images moderate skipped" do
    get :moderate_skipped
    assert_response :success
  end

  test "should get to moderate flagged" do
    get :moderate_flagged
    assert_response :success
  end

  test "should get flagging history" do
    get :flagging_history
    assert_response :success
  end

  test "should get to manual images input" do
    get :manual_input
    assert_response :success
  end

end
