require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    
    get signup_path
    assert_select "title", full_title("Sign up")
    
    user = users(:katherine)
    login_as(user)
    follow_redirect!
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", edit_user_path(user)
  end
end
