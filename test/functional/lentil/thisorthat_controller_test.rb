require 'test_helper'

class Lentil::ThisorthatControllerTest < ActionController::TestCase
  def setup
    @routes = Lentil::Engine.routes
  end

  test "should get battle leaders" do
    get :battle_leaders
    assert_response :success
  end

end
