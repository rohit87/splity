module UsersHelper

    # Returns the Gravatar (http://gravatar.com/) for the given user.
    def profile_picture_for(user, dimension=80)
      image_url = profile_picture_url_for user, dimension
      image_tag(image_url, alt: user.name, class: "img-thumbnail", height: dimension, width: dimension)
    end

    def profile_picture_url_for(user, dimension=80)
      user.image_url.nil? ? "https://secure.gravatar.com/avatar/#{Digest::MD5::hexdigest(user.email.downcase)}?s=#{dimension}&d=identicon" : user.image_url
    end

    def authenticate_user(user, password)
      if user && user.authenticate(password)
        sign_in user
        redirect_to user
      else
        flash[:danger] = 'Invalid email/password combination'
        redirect_to signin_url
      end
    end

    def authenticate_app_user(user, password)
      if user && user.authenticate(password)
        sign_in(user, { from_app?: true })
        return {
          success: true,
          user: current_user,
        }
      else
        return {
          success: false
        }
      end
    end

    def sign_in(user, options={})
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
      splity_session = cookies[:splity_session] || params[:splity_session]
      remember_token = User.digest splity_session
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

    def correct_user?
      current_user? User.find_by id: params[:id]
    end

    def correct_user
      unless correct_user?
        flash[:warning] = "You do not have permissions to view the page you requested!"
        redirect_to signin_url
      end
    end
    
end