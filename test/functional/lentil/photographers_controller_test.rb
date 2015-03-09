require 'test_helper'

class Lentil::PhotographersControllerTest < ActionController::TestCase
  def setup
    @routes = Lentil::Engine.routes
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show view" do
    get :show, :id => lentil_users(:bd).id
    assert_response :success
  end

end
