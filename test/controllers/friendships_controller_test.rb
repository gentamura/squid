require 'test_helper'

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:foo)
    @other_user = users(:bar)
  end

  test "should get index" do
    log_in_as(@user)
    get friendships_path
    assert_response :success
  end

  test "should get new" do
    log_in_as(@user)
    get new_friendship_path(@other_user)
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get friendships_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect new when not logged in" do
    get new_friendship_path(@other_user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect create when not logged in" do
    post friendships_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should a friend added" do
    log_in_as(@user)
    assert_difference "Friendship.count", 1 do
      post friendships_path, params: {
        friendship: {
          user_id: @user.id,
          friend_id: @other_user.id
        }
      }
    end
    assert_redirected_to friendships_path
  end

  test "should not a friend added" do
    log_in_as(@user)
    assert_no_difference "Friendship.count" do
      post friendships_path, params: {
        friendship: {
          user_id: nil,
          friend_id: nil
        }
      }
    end
    assert_redirected_to users_path
  end

end
