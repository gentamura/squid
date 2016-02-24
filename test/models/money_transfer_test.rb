require 'test_helper'

class MoneyTransferTest < ActiveSupport::TestCase
  def setup
    @sender = users(:foo)
    @receiver = users(:bar)
    # @money_transfer = @sender.money_transfers.build(receiver_id: @receiver.id, amount: 100, message: "hello")
    @money_transfer = @sender.money_senders.build(receiver_id: @receiver.id, amount: 100, message: "hello")
  end

  test "should be valid" do
    assert @money_transfer.valid?
  end

  test "should require a sender_id" do
    @money_transfer.sender_id = nil
    assert_not @money_transfer.valid?
  end

  test "should require a receiver_id" do
    @money_transfer.receiver_id = nil
    assert_not @money_transfer.valid?
  end

  test "should require a mount" do
    @money_transfer.amount = nil
    assert_not @money_transfer.valid?
  end

  test "should require a mount as integer" do
    @money_transfer.amount = "string"
    assert_not @money_transfer.valid?
  end
end
