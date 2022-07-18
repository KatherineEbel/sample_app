require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:katherine)
  end
  
  test "unsuccessful edit" do
    login_as(@admin_user)
    get edit_user_path(@admin_user)
    assert_template 'users/edit'
    patch user_path(@admin_user), params: { user: {
      name: "",
      email: "foo@invalid",
      password: "foo",
      password_confirmation: "bar"
    }}
    assert_template "users/edit"
    assert_select ".error-count", "The form contains 4 errors"
  end
  
  test "successful edit" do
    login_as(@admin_user)
    get edit_user_path(@admin_user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@admin_user), params: { user: {
      name: name,
      email: email,
      password: "",
      password_confirmation: ""
    }}
    assert_not flash.empty?
    assert_redirected_to @admin_user
    @admin_user.reload
    assert_equal name, @admin_user.name
    assert_equal email, @admin_user.email
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path @admin_user
    login_as(@admin_user)
    assert_redirected_to edit_user_url(@admin_user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@admin_user), params: { user: {
      name: name,
      email: email,
      password: "",
      password_confirmation: "",
    }}
    assert session[:forwarding_url] == nil
    assert_not flash.empty?
    assert_redirected_to @admin_user
    @admin_user.reload
    assert_equal name, @admin_user.name
    assert_equal email, @admin_user.email
  end
end
