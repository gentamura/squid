require 'test_helper'

class MoneyTransfersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:foo)
    @other_user = users(:bar)
  end

  test "should redirect index when not logged in" do
    get money_transfers_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect new when not logged in" do
    get new_money_transfer_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect create when not logged in" do
    post money_transfers_path, params: {
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

  test "valid transfer" do
    log_in_as(@user)
    assert_difference "MoneyTransfer.count", 1 do
      post money_transfers_path, params: {
        id: @user.id,
        money_transfer: {
          sender_id: @user.id,
          receiver_id: @other_user.id,
          amount: 1000,
          message: "Success transfer?"
        }
      }
    end
    assert_redirected_to money_transfers_path
  end

  test "Invalid transfer" do
    log_in_as(@user)
    assert_no_difference "MoneyTransfer.count" do
      post money_transfers_path, params: {
        id: @user.id,
        money_transfer: {
          sender_id: @user.id,
          receiver_id: @other_user.id,
          amount: nil,
          message: "Fail transfer."
        }
      }
    end
    assert_select 'h1', 'Money transfer'
    assert_response :success
  end

end
