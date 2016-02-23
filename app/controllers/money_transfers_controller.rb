class MoneyTransfersController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create]

  def index
  end

  def new
    # TODO : change from array to ActiveRecord::Associations
    @receivers = Friendship.receivers(current_user)
    @assigned_receiver = assigned_receiver(@receivers)
  end

  def create
    begin
      money_transfer = current_user.money_senders.build(money_transfer_params)
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

    def assigned_receiver(receivers)
      assigned_receiver?(receivers) ? receivers.find(params[:receiver_id]) : ""
    end

    def assigned_receiver?(receivers)
      # TODO : Not working
      params[:receiver_id] and receivers.exists?(id: params[:receiver_id].to_i)
    end
end
