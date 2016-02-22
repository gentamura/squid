class FriendshipsController < ApplicationController
  def index
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
      flash.now[:warning] = "Failed."
      @friend = User.find(friendship.friend_id)
      render 'new'
    end
  end

  private
    def friendship_params
      params.require(:friendship).permit(:user_id, :friend_id)
    end

end
