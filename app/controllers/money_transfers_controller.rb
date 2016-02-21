class MoneyTransfersController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create]
  before_action :correct_user, only: [:index, :new, :create]

  def index
  end

  def new
    @friends = current_user.friends
  end

  def create
    begin
      money_transfer = current_user.money_transfers.build(money_transfer_params)
      money_transfer.exec_transaction
      flash[:success] = "sent!"
      redirect_to user_money_transfers_url(current_user)
    rescue
      flash[:warning] = "Not sent."
      render 'new'
    end
  end

  private
    def money_transfer_params
      params.require(:user_money_transfer).permit(:receiver_id, :amount, :message)
    end

    def correct_user
      correct_user_base params[:user_id]
    end
end
