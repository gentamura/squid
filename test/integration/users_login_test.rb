require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @activated_user = users(:foo)
    @unactivated_user = users(:baz)
  end

  test "login with invalid information" do
    get login_path
    assert_select 'h1', 'Log in'
    post login_path, params: { session: { email: "", password: "" } }
    assert_select 'h1', 'Log in'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @activated_user.email, password: "foobarbaz" } }
    assert is_logged_in?
    assert_redirected_to @activated_user
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@activated_user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@activated_user), count: 0
  end

  test "user login with remembering" do
    log_in_as(@activated_user)
    assert_not_nil cookies['remember_token']
  end

  test "user login with not activated" do
    log_in_as(@unactivated_user)
    assert_not is_logged_in?
  end

  test "user login with invalid activation token" do
    user = @unactivated_user
    assign_activation(user)
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
  end

  test "user login with invalid email" do
    user = @unactivated_user
    assign_activation(user)
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
  end

  test "user login with valid activation token" do
    user = @unactivated_user
    assign_activation(user)
    get edit_account_activation_path(user.activation_token, email: user.email)
    follow_redirect!
    assert @controller.instance_variable_get(:@user).activated?
    assert_select 'div.alert-success', 'Account activated!'
    assert_select 'h1', 'User page'
    assert is_logged_in?
  end

  private
    def assign_activation(user)
      user.send(:create_activation_digest)
      user.update_attribute(:activation_digest, user.activation_digest)
    end
end
