class Api::AuthenticationController < Api::BaseController

  before_filter :validate_access_token, only: [:me, :logout]
  before_filter :validate_current_user, only: [:me, :logout]
  before_filter :validate_login_request, only: [:login]

  def login
    user = User.find_by email: params[:email]
    render json: { err: "Invalid credentials!" }, status: 401 and return if user.nil? || !user.authenticate(params[:password])

    render json: {
      access_token: signin_user(user),
      user: user.serializable_hash.except("password_digest")
    }, status: 200
  end

  def me
    begin
      render json: { user: current_user.serializable_hash.except("password_digest") }
    rescue => e
      puts e.message
      puts e.backtrace.join("\r\n")
    end
  end

  def logout
    signout_user 
    render json: { err: nil }
  end

  private

    def validate_login_request
      render json: { err: "Invalid login request!" }, status: 400 and return if !valid_login_request?
    end

    def valid_login_request?
      return false if !params[:email].present?
      return false if !params[:password].present?
      return false if !params.except(:email).except(:password).except(:controller).except(:action).blank?
      return false if !access_token.blank?
      return true
    end

    def validate_access_token
      render json: { err: "Must provide access token!" }, status: 400 and return if access_token.nil? or access_token.blank?
    end

    def validate_current_user
      render json: { err: "Invalid access token!" }, status: 401 and return if current_user.nil?
    end

    def signin_user(user)
      remember_token = User.new_remember_token
      user.update_attribute(:remember_token, User.digest(remember_token))
      return remember_token
    end

    def signout_user
      current_user.update_attribute(:remember_token, User.digest(User.new_remember_token))
    end

end