require 'test_helper'

class AdminTagsetTest < ActionDispatch::IntegrationTest

  setup do
    login_admin_user
  end

  test "should get edit form for tagset" do
    visit edit_admin_lentil_tagset_path(lentil_tagsets(:one))
    assert page.has_selector?('input[@value="Update Tagset"]')
  end

end
