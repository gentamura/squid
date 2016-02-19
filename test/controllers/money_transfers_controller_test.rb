require 'test_helper'

class MoneyTransfersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:foo)
    @other_user = users(:bar)
  end

  test "should redirect index when not logged in" do
    get user_money_transfers_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect new when not logged in" do
    get new_user_money_transfer_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect create when not logged in" do
    post user_money_transfers_path(@user), params: {
      money_transfer: {
        sender_id: @user.id,
        receiver_id: @other_user.id,
        amount: 100,
        message: "hello"
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect index when logged in as wrong user" do
    log_in_as(@other_user)
    get user_money_transfers_path(@user), params: { id: @user.id }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect new when logged in as wrong user" do
    log_in_as(@other_user)
    get new_user_money_transfer_path(@user), params: { id: @user.id }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    post user_money_transfers_path(@user), params: {
      id: @user.id,
      money_transfer: {
        sender_id: @user.id,
        receiver_id: @other_user.id,
        amount: 100,
        message: "hello"
      }
    }
    assert flash.empty?
    assert_redirected_to root_url
  end

end
