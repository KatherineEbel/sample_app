require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:katherine)
    @non_admin = users(:sydney)
  end
  
  test "index including pagination" do
    login_as(@admin)
    get users_path
    assert_template "users/index"
    assert_select "div.pagination"
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
  end
  
  test "index as admin including pagination and delete links" do
    login_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page = User.paginate(page: 1)
    first_page.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'form[action=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
      assert_response :see_other
      assert_redirected_to users_url
    end
  end
  
  test "index as non-admin" do
    login_as @non_admin
    get users_path
    assert_select 'button[type=submit] span.destroy', count: 0
  end
end
