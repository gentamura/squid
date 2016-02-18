require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:foo)
  end

  test "password resets" do
    get new_password_reset_path
    assert_select 'h1', text: 'Forgot password'
    # Invalid email address.
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_select 'h1', text: 'Forgot password'
    # Valid email address.
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    user = @controller.instance_variable_get(:@user)
    # Invalid email address.
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Invalid user.
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Valid user, invalid token.
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Valid email address and token.
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_select 'h1', 'Reset password'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid confirm password
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: "hogefuga",
        password_confirmation: "hogehoge"
      }
    }
    assert_select 'h1', 'Reset password'
    # Empty password
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: "",
        password_confirmation: ""
      }
    }
    assert_select 'h1', 'Reset password'
    # Valid password
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: "hogehoge",
        password_confirmation: "hogehoge"
      }
    }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, params: { password_reset: { email: @user.email } }

    user = @controller.instance_variable_get(:@user)
    user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: "hogehoge",
        password_confirmation: "hogehoge"
      }
    }
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, @response.body
  end
end
