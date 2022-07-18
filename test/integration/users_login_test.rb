require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:katherine)
  end
  
  test "login flash" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: "", password: "" } }
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with valid information" do
    get login_path
    login_as(@admin_user)
    assert_redirected_to @admin_user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select 'form[action=?]', logout_path
    assert_select "a[href=?]", user_path(@admin_user)
  end
  
  test "login with valid email/invalid password" do
    get login_path
    assert_template "sessions/new"
    login_as(@admin_user, password: 'invalid')
    
    assert_not is_logged_in?
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with valid information followed by logout" do
    get login_path
    login_as(@admin_user)
    assert is_logged_in?
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # simulate a user clicking logout in second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@admin_user), count: 0
  end
  
  test "login with remembering" do
    login_as(@admin_user, remember_me: '1')
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end
  
  test "login without remembering" do
    # log in to set the cookie
    login_as(@admin_user, remember_me: '1')
    # log in again and verify that the cookie is deleted
    login_as(@admin_user, remember_me: '0')
    assert cookies[:remember_token].blank?
  end
end
