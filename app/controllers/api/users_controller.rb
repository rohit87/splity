class Api::UsersController < Api::BaseController

  def get
    render json: { err: "Could not find user with id #{user_id}" }, status: 404 and return if user_to_fetch.nil?
    render json: { user: user_to_fetch }
  end

  def create
    user = User.create user_to_create
    render json: { err: "Invalid user!", errors: user.errors.full_messages }, status: 400 and return if !user.valid?
    user.save! and render json: { user: user }, status: 200 and return
  end

  def delete
    render json: { err: "Unauthorized to delete that account!" }, status: 401 and return if (current_user.nil? || current_user.id != user_id)
    render json: { err: "Incorrect user id provided!" }, status: 404 and return if user_to_delete.nil?
    current_user.delete
    render json: { err: nil }, status: 200
  end

  def update
    puts params
    render json: { err: "Unauthorized!" }, status: 401 and return if (current_user.nil? || current_user.id != user_id)
    render json: { err: "No attributes to update!" }, status: 400 and return if params[:attributes].nil?
  end

  private

    def user_id
      params[:user_id].to_i
    end

    def user_to_fetch
      user = User.find_by(id: user_id)
      user.nil? ? nil : user.serializable_hash.except!("password_digest")
    end

    def user_to_delete
      User.find_by id: user_id
    end

    def user_to_create
      @user_to_create ||= JSON.parse(request.body.read)["user"].symbolize_keys!
    end

    def user_to_create_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end