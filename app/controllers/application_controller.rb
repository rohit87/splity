class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include StaticAssets::Javascripts

  before_filter :initialize_javascripts
  # after_action :finalize_javascripts


  include UsersHelper
  include GlobalConstants
end
