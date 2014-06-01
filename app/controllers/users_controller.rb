class UsersController < ApplicationController
  
  before_action :signed_in_user, only: [:index, :friends, :unfriend, :logout, :home, :show, :patch]
  before_action :correct_user, only: [:friends, :patch]
  
  def index
    @users = User.paginate page: params[:page], per_page: 10
    redirect_to users_path and return if @users.empty?
    render 'users/list'
  end

  def new
    @user = User.new
  end

  def show
    redirect_to root_url and return if current_user.id.to_s == params[:id]
    @user = User.find(params[:id])
  end

  def home
    @user = current_user
    @dashboard = user_dashboard(current_user)
    render 'show'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to SplityApp!"
      @user.notifications << WelcomeNotification.new(@user)
      UserMailer.welcome_email(@user).deliver
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

  def patch
    result = current_user.patch params[:name].to_sym, params[:value]
    if result[:valid]
      render :json => { err: nil }
    else
      render :json => { err: true, msg: result[:errors].first }, status: :bad_request
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def user_dashboard(user)
      participations = user.participations
      incoming = []
      payments = []
      debts = []
      p = {}
      participations.each do |participation|
        
        if !participation.resolved
          payments << {
            activity: "#{participation.activity.event} @ #{participation.activity.location}",
            amount_paid: participation.amount_paid.to_i,
            total_amount: participation.activity.amount.to_i,
            id: participation.id
          }
        end
        
        if participation.amount_owed != nil && !participation.resolved
          debts << {
            activity: "#{participation.activity.event} @ #{participation.activity.location}",
            amount_owed: participation.amount_owed,
            amount_owed_to: participation[:amount_owed_to],
            amount_owed_to_name: User.find(participation[:amount_owed_to]).name,
          }
        end
      end

      Participation
        .where("user_id != :user_id AND amount_owed_to = :amount_owed_to AND resolved = false", {
          user_id: user.id,
          amount_owed_to: user.id
        }).each do |p|
          incoming << {
            amount: p[:amount_owed],
            from: User.find(p[:user_id]).name
          }
        end
      return {
        participations: participations,
        payments: payments,
        incoming: incoming,
        debts: debts,
        total_debt: debts.collect{|d| d[:amount_owed]}.reduce(:+),
        total_paid: payments.collect{|d| d[:amount_paid]}.reduce(:+),
        total_amount: payments.collect{|d| d[:total_amount]}.reduce(:+)
      }
    end

end
