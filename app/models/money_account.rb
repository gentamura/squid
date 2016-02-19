class MoneyAccount < ApplicationRecord
  belongs_to :user
  validates :balance, presence: true

  def withdraw(amount)
    # TODO : Need implement a exception.
    update_attribute(:balance, balance - amount)
  end

  def deposit(amount)
    # TODO : Need implement a exception.
    update_attribute(:balance, balance + amount)
  end
end
