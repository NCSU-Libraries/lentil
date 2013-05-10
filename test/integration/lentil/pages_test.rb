require 'test_helper'

class PagesTest < ActionDispatch::IntegrationTest

  test "should have about page" do
    visit lentil.pages_about_path
    assert page.has_content?('About')
    assert page.has_content?('Create the file app/views/lentil/pages/about.html.erb and fill it with whatever you want.')
  end

end