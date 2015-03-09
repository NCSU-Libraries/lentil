require 'test_helper'

class Lentil::FlagsControllerTest < ActionController::TestCase

  setup do
    @request.env['HTTP_REFERER'] = '/'
    @routes = Lentil::Engine.routes
  end

  test "should post tally" do
    post :tally, :image_id => lentil_images(:one).id
    assert_response 302
  end

  test "should save image id in session when posting a tally" do
    post :tally, :image_id => lentil_images(:one).id
    assert session["flagged_images"].include?(lentil_images(:one).id.to_s)
  end

end
