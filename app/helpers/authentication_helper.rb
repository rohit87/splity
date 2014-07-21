module AuthenticationHelper

  def access_token
    @access_token ||= (request.headers["X-Authorization-Token"] || params["X-Authorization-Token"])
  end

  def current_user
    token = User.digest access_token
    @current_user ||= User.find_by(remember_token: token)
  end

end