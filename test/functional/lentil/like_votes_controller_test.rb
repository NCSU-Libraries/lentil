require 'test_helper'

class Lentil::LikeVotesControllerTest < ActionController::TestCase

  setup do
    @request.env['HTTP_REFERER'] = '/'
  end

  test "should post tally" do
    post :tally, :image_id => lentil_images(:one).id, :use_route => :lentil
    assert_response 302
  end

  test "should save image id in session when posting a tally" do
    post :tally, :image_id => lentil_images(:one).id, :use_route => :lentil
    assert session["liked_images"].include?(lentil_images(:one).id.to_s)
  end

end
