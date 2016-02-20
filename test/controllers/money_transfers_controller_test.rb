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
      user_money_transfer: {
        sender_id: @user.id,
        receiver_id: @other_user.id,
        amount: 100,
        message: "hello"
      }
    }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "valid transfer" do
    log_in_as(@user)
    assert_difference "MoneyTransfer.count", 1 do
      post user_money_transfers_path(@user), params: {
        user_money_transfer: {
          sender_id: @user.id,
          receiver_id: @other_user.id,
          amount: 1000,
          message: "Success transfer?"
        }
      }
    end
    assert_redirected_to user_money_transfers_path(@user)
  end

  test "Invalid transfer" do
    log_in_as(@user)
    assert_no_difference "MoneyTransfer.count" do
      post user_money_transfers_path(@user), params: {
        user_money_transfer: {
          sender_id: @user.id,
          receiver_id: @other_user.id,
          amount: nil,
          message: "Fail transfer."
        }
      }
    end
    assert_select 'h1', 'MoneyTransfers#new'
    assert_response :success
  end

end
