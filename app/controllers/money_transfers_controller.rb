class MoneyTransfersController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create]
  before_action :receiver, only: :new

  def index
  end

  def new
  end

  def create
    begin
      @money_transfer = current_user.money_senders.build(money_transfer_params)
      @money_transfer.exec_transaction
      flash[:success] = "Send successed!"
      redirect_to money_transfers_url
    rescue
      flash.now[:warning] = "Send Failed. Please enter correct value."
      receiver
      render 'new'
    end
  end

  private
    def receiver
      @receiver_friends = Friendship.receiver_friends(current_user)
      @assigned_receiver = assigned_receiver(@receiver_friends)
    end

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
