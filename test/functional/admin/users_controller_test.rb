require 'test_helper'

class AdminUsersControllerTest < ActionController::TestCase

  setup do
    @controller = ::Admin::LentilUsersController.new
    user = lentil_admin_users(:one)
    sign_in user
  end

  test "should get to images index" do
    get :index
    assert_response :success
  end

end
