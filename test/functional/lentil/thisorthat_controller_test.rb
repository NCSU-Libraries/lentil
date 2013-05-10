require 'test_helper'

class Lentil::ThisorthatControllerTest < ActionController::TestCase
  test "should get battle leaders" do
    get :battle_leaders, :use_route => :lentil
    assert_response :success
  end

end
