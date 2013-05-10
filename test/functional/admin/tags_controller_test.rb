require 'test_helper'

class AdminTagsControllerTest < ActionController::TestCase

  setup do
    @controller = ::Admin::LentilTagsController.new
    user = lentil_admin_users(:one)
    sign_in user
  end

  test "should get to images index" do
    get :index, :use_route => :lentil
    assert_response :success
  end

end