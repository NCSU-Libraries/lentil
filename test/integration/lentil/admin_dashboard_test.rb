require 'test_helper'

class AdminDashboardTest < ActionDispatch::IntegrationTest

  setup do
    login_admin_user
  end

  test "should be able to get to flagged image from dashboard" do
    within "#recently_flagged" do
      all('a').first.click
    end
    assert page.has_content?('Image Details')
  end

  # FIXME: for these blank slate tests there is probably a better way to just not load these in the first place.
  test "should see blank slates when there are no images" do
    Lentil::Image.all.each{|image| image.destroy}
    visit admin_dashboard_path
    assert page.has_content?('No New Images')
    assert page.has_content?('No Recently Flagged Images')
    assert page.has_content?('No Top Images Found')
  end

  test "should see blank slate when there are no users" do
    Lentil::User.all.each{|user| user.destroy}
    visit admin_dashboard_path
    assert page.has_content?('No Users Found')
  end

end
