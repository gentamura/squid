require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
      post_via_redirect users_path, params: {
        user: {
          name: "valid user",
          email: "valid@user.com",
          password: "foobarbaz",
          password_confirmation: "foobarbaz"
        }
      }
    end
    assert_select 'h1', test: 'User page'
  end
end
