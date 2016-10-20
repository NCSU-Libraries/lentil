require 'test_helper'

class AdminFlagsControllerTest < ActionController::TestCase

  setup do
    @controller = ::Admin::LentilFlagsController.new
    user = lentil_admin_users(:one)
    sign_in user
  end

  test "should get to images index" do
    get :index
    assert_response :success
  end

end
