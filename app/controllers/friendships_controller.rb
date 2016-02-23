class FriendshipsController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create]

  def index
    @friends = Friendship.friends(current_user)
  end

  def new
    @friend = User.find(params[:id])
    @friendship = Friendship.new
  end

  def create
    friendship = Friendship.new(friendship_params)
    if friendship.save
      flash[:success] = "Success!"
      redirect_to friendships_path
    else
      flash[:warning] = "Failed."
      redirect_to users_path
    end
  end

  private
    def friendship_params
      params.require(:friendship).permit(:user_id, :friend_id)
    end

end
