require 'test_helper'
require 'pp'
class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      }
    end
    assert_select 'h1', text: 'Sign up'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: "valid user",
          email: "valid@user.com",
          password: "foobarbaz",
          password_confirmation: "foobarbaz"
        }
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

end
