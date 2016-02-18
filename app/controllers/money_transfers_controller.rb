class MoneyTransfersController < ApplicationController
  before_action :logged_in_user, only: [:index, :new]

  def index

  end

  def new
  end
=begin
MoneyTransfer:0x007ffeca54bf98
  id: nil,
  sender_id: nil,
  receiver_id: nil,
  amount: nil,
  message: nil,
  created_at: nil,
  updated_at: nil
=end

  def create
    money_transfer = current_user.money_transfers.build(money_transfer_params)
    puts "money_transfer: #{money_transfer}"
    # if money_transfer.save
    #
    # else
    #
    # end
  end

  private
    def money_transfer_params
      params.require(:money_transfer).permit(:receiver_id, :amount, :message)
    end
end
