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

  test "should decrease a balance by withdraw" do
    amount = 500
    balance = @money_account.balance
    @money_account.withdraw(amount)
    assert_equal @money_account.balance, balance - amount
  end

  test "should increase a balance by deposit" do
    amount = 500
    balance = @money_account.balance
    @money_account.deposit(amount)
    assert_equal @money_account.balance, balance + amount
  end

  test "should raise a exception by withdraw" do
  end

end
