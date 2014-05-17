module UsersHelper

    # Returns the Gravatar (http://gravatar.com/) for the given user.
    def gravatar_for(user)
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
      image_tag(gravatar_url, alt: user.name, class: "gravatar img-thumbnail", height: 80, width: 80)
    end

    def authenticate_user(user)
      if user && user.authenticate(params[:user][:password])
        sign_in user
        redirect_to user
      else
        flash[:danger] = 'Invalid email/password combination'
        redirect_to signin_url
      end
    end

    def sign_in(user)
      remember_token = User.new_remember_token
      cookies.permanent[:splity_session] = remember_token
      user.update_attribute(:remember_token, User.digest(remember_token))
      self.current_user = user
    end

    def sign_out
      cookies.delete :splity_session
      current_user = nil
    end

    def current_user=(user)
      @current_user = user
    end

    def current_user?(user)
      return false if user.nil?
      signed_in? && current_user.id == user.id
    end

    def current_user
      remember_token = User.digest cookies[:splity_session]
      @current_user ||= User.find_by remember_token: remember_token
    end

    def signed_in?
      !current_user.nil?
    end

    def signed_in_user
      unless signed_in?
        flash[:warning] = "Please sign in."
        redirect_to signin_url
      end
    end

    def correct_user
      unless current_user?(User.find_by id: params[:id])
        flash[:warning] = "You do not have permissions to view the page you requested!"
        redirect_to signin_url
      end
    end
    
end
