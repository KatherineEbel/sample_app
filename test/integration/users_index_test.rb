require "test_helper"

class UsersIndex < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:katherine)
    @non_admin = users(:sydney)
  end
end

class UsersIndexAdmin < UsersIndex
  def setup
    super
    login_as @admin
    get users_path
  end
end

class UsersIndexAdminTest < UsersIndexAdmin
  test "should render the index page" do
    assert_template 'users/index'
  end
  
  test "should have delete links" do
    first_page = User.where(activated: true).paginate(page: 1)
    first_page.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'form[action=?]', user_path(user), text: 'delete'
      end
    end
  end
  
  test "should be able to delete non-admin user" do
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
      assert_response :see_other
      assert_redirected_to users_url
    end
  end
  
  test "should display only activated users" do
    User.paginate(page: 1).first.toggle!(:activated)
    assigns(:users).each do |user|
      assert user.activated?
    end
  end
end

class UsersNonAdminIndexTest < UsersIndex
  test "should not have delete links as non-admin" do
    login_as @non_admin
    get users_path
    assert_select 'button[type=submit] span.destroy', count: 0
  end
end
