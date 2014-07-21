class Api::BaseController < ApplicationController
  
  include AuthenticationHelper
  
  skip_before_filter :verify_authenticity_token
  around_filter :safe_invoke
  
  def safe_invoke
    begin
      yield
    rescue => e
      details = "#{e.message} \r\n #{e.backtrace.join("\r\n")}"
      render json: { err: details }, status: 500
      puts "#{e.message} \r\n #{e.backtrace.join("\r\n")}"
    end
  end

  def not_found
    render json: {
      err: "Route not found!"
    }, status: 404
  end

end