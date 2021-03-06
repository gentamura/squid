require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "user test", email: "user@example.com", password: "foobarbaz", password_confirmation: "foobarbaz")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 255 + "@foo.com";
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid."
    end
  end

  test "email validation should reject invalid address" do
    invalid_addresses =  %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address} should be invalid."
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (non blank)" do
    @user.password = @user.password_confirmation = " " * 8
    assert_not @user.valid?
  end

  test "password should be a minimum length" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "activate should make a money account for user" do
    @user.save
    @user.activate
    assert @user.money_account
  end

  test "destroy should destroy a money account for user" do
    @user.save
    @user.activate
    @user.destroy
    assert_not MoneyAccount.find_by(user_id: @user.id)
  end

  test "should friend and unfriend a user" do
    user = users(:foo)
    other_user = users(:bar)
    assert_not user.friend?(other_user)
    user.friend(other_user)
    assert user.friend?(other_user)
    user.unfriend(other_user)
    assert_not user.friend?(other_user)
  end

  test "should include current user id as receiver id in money sender collection" do
    user = users(:foo)
    senders = user.money_senders
    assert senders.all? { |sender| sender.receiver_id == user.id }
  end

  test "should include current user id as sender id in money receiver collection" do
    user = users(:foo)
    receivers = user.money_receivers
    assert receivers.all? { |receiver| receiver.sender_id == user.id }
  end

  test "should include current user id in money transfer timeline" do
    user = users(:foo)
    timeline = user.money_transfer_current_user_all
    assert timeline.all? { |line| line.sender_id == user.id or line.receiver_id == user.id  }
  end
end
