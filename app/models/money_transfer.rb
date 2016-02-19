class MoneyTransfer < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  validates :sender_id,  presence: true
  validates :receiver_id, presence: true
  validates :amount, presence: true

  def exec_transaction
    transaction do
      sender.money_account.withdraw amount
      receiver.money_account.deposit amount
      save!
    end
  end

end
