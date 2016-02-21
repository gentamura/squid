require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  def setup
    user = users(:foo)
    friend = users(:bar)
    @friendship = user.friendships.build(user_id: user.id, friend_id: friend.id)
  end

  test "should be valid" do
    assert @friendship.valid?
  end

  test "should require a user_id" do
    @friendship.user_id = nil
    assert_not @friendship.valid?
  end

  test "should require a friend_id" do
    @friendship.friend_id = nil
    assert_not @friendship.valid?
  end
end
