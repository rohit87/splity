class UsersController < ApplicationController
  
  before_action :signed_in_user, only: [:index, :friends, :unfriend, :logout]
  before_action :correct_user, only: [:friends]
  
  def index
    @users = User.paginate page: params[:page], per_page: 10
    redirect_to users_path and return if @users.empty?
    render 'users/list'
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to SplityApp!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def authenticate
    redirect_to user_url current_user and return if signed_in?
    render 'users/login' and return if request.get?
    authenticate_user User.find_by(email: params[:user][:email].downcase)
  end

  def logout
    sign_out
    redirect_to signin_url
  end

  def friends
    @friends = current_user.friends.paginate page: params[:page]
    return if request.get?
    requested_friend = User.find_by(email: params[:friend][:email])
    if requested_friend.nil?
      flash[:danger] = "There's nobody by that email address here!"
      redirect_to friends_user_url current_user and return
    end
    current_user.create_friendship! requested_friend
    redirect_to friends_user_url(current_user)
  end

  def unfriend
    friend = User.find params[:friend][:id]
    current_user.unfriend! friend
    redirect_to friends_user_url current_user
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
