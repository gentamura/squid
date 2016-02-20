class MoneyAccount < ApplicationRecord
  belongs_to :user
  validates :balance, presence: true

  def withdraw(amount)
    update_attributes!(balance: balance - amount)
  end

  def deposit(amount)
    update_attributes!(balance: balance + amount)
  end
end
