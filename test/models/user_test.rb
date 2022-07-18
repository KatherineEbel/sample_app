require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @admin_user = User.new(name:     "Example User", email: "user@example.com",
                           password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @admin_user.valid?
  end
  
  test "name should be present" do
    @admin_user.name = "    "
    assert_not @admin_user.valid?
  end
  
  test "email should be present" do
    @admin_user.email = "   "
    assert_not @admin_user.valid?
  end
  
  test "name should not be too long" do
    @admin_user.name = "a" * 51
    assert_not @admin_user.valid?
  end

  test "email should not be too long" do
    @admin_user.name = "a" * 244 + "@example.com"
    assert_not @admin_user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-Er@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |addr|
      @admin_user.email = addr
      assert @admin_user.valid?, "#{addr.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    valid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    valid_addresses.each do |addr|
      @admin_user.email = addr
      assert_not @admin_user.valid?, "#{addr.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @admin_user.dup
    @admin_user.save
    assert_not duplicate_user.valid?
  end
  
  test "email addresses should be saved as lowercase" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @admin_user.email = mixed_case_email
    @admin_user.save
    assert_equal mixed_case_email.downcase, @admin_user.reload.email
  end
  
  test "password should be present (nonblank)" do
    @admin_user.password = @admin_user.password_confirmation = " " * 6
    assert_not @admin_user.valid?
  end

  test "password should have mininum length" do
    @admin_user.password = @admin_user.password_confirmation = "a" * 5
    assert_not @admin_user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @admin_user.authenticated? ""
  end
end
