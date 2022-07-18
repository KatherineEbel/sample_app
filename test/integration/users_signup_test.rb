require "test_helper"

class UsersSignup < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class UsersSignupTest < UsersSignup
  test 'invalid signup information' do
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:                  "",
                                         email:                 "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar"}}
    end
    assert_template 'users/new'
    assert_select '.field_with_errors', 8
  end

  test 'valid signup information with account activation' do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:                  "valid user",
                                         email:                 "user@valid.com",
                                         password:              "foobar",
                                         password_confirmation: "foobar"}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end

class AccountActivationTest < UsersSignup
  def setup
    super
    post users_path, params: { user: {
      name: "Example User",
      email: "user@example.com",
      password: "password",
      password_confirmation: "password"
    }}
    # assigns looks for instance variable @user in controller
    # provided by rails-controller-testing gem
    @user = assigns(:user)
  end
  
  test "should not be activated" do
    assert_not @user.activated?
  end
  
  test "should not be allowed to log in before activation" do
    login_as(@user)
    assert_not is_logged_in?
  end
  
  test "should not be able to log in with invalid activation token" do
    get edit_account_activation_url("invalid token", email: @user.email)
    assert_not is_logged_in?
  end
  
  test "should not be able to log in with invalid email" do
    get edit_account_activation_url(@user.activation_token, email: 'user@hacker.com')
    assert_not is_logged_in?
  end
  
  test "should log in successfully with valid activation token and email" do
    get edit_account_activation_url(@user.activation_token, email: @user.email)
    assert is_logged_in?
  end
end