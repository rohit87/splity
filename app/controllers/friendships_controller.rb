class FriendshipsController < ApplicationController

  def create
    friend = User.find(params[:email])
    current_user.friends << friend
    friend.friends << current_user
    # current_user.create_friendship! @user
    redirect_to friends_user_url(current_user)
  end

end