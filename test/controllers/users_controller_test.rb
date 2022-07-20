require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:katherine)
    @non_admin= users(:sydney)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  test "should redirect edit when not logged in" do
    get edit_user_path(@admin_user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    patch user_path(@admin_user), params: { admin_user: {
      name:  @admin_user.name,
      email: @admin_user.email
    }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect edit when logged in as wrong user" do
    login_as(@non_admin)
    get edit_user_path(@admin_user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    login_as(@non_admin)
    patch user_path(@admin_user), params: { admin_user: {
      name:  @admin_user.name,
      email: @admin_user.email
    }}
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "should not be able to update admin attribute" do
    login_as(@non_admin)
    assert_not @non_admin.admin?
    patch user_path(@non_admin), params: { user: {
      password: "password",
      password_confirmation: "password",
      admin: true,
    }}
    assert_not @non_admin.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@admin_user)
    end
    
    assert_response :see_other
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when logged in as a non-admin" do
    login_as(@non_admin)
    assert_no_difference 'User.count' do
      delete user_path(@admin_user)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end
  
  test "should redirect following when not logged in" do
    get following_user_path(@admin_user)
    assert_redirected_to login_url
  end
  
  test 'should redirect followers when not logged in' do
    get followers_user_path(@admin_user)
    assert_redirected_to login_url
  end
end
