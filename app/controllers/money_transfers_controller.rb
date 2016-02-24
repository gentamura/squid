class MoneyTransfersController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create]

  def index
  end

  def new
    @receiver_friends = Friendship.receiver_friends(current_user)
    @assigned_receiver = assigned_receiver(@receiver_friends)
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
      user = valid_params? ? User.find(params[:receiver_id].to_i) : nil
      user if user.present? and receivers.include?(user)
    end

    def valid_params?
      params[:receiver_id].present? and User.exists?(params[:receiver_id])
    end
end
