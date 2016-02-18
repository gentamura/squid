require 'test_helper'

class MoneyAccountTest < ActiveSupport::TestCase
  def setup
    @user = users(:foo)
    @money_account = @user.build_money_account(balance: 1000)
  end

  test "should be valid" do
    assert @money_account.valid?
  end

  test "should require a balance" do
    @money_account.balance = nil
    assert_not @money_account.valid?
  end
end
