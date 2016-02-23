class MoneyTransfersController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create]

  def index
  end

  def new
    @friends = current_user.friends
    if params[:receiver_id]
      if @friends.exists? id: params[:receiver_id].to_i
        @friend_name = @friends.find(params[:receiver_id])
      else
        @friend_name = ""
      end
    else
      @friend_name = ""
    end
  end

  def create
    begin
      money_transfer = current_user.money_transfers.build(money_transfer_params)
      money_transfer.exec_transaction
      flash[:success] = "sent!"
      redirect_to money_transfers_url
    rescue
      flash.now[:warning] = "Not sent."
      render 'new'
    end
  end

  private
    def money_transfer_params
      params.require(:money_transfer).permit(:receiver_id, :amount, :message)
    end
end
