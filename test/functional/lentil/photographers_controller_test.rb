require 'test_helper'

class Lentil::PhotographersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, :use_route => :lentil
    assert_response :success
  end

  test "should get show view" do
    get :show, :id => lentil_users(:jr).id, :use_route => :lentil
    assert_response :success
  end

end
