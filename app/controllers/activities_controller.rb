class ActivitiesController < ApplicationController

  before_action :signed_in_user, except: [:create]
  protect_from_forgery :except => [:create]

  def index
    @activities = current_user.activities.paginate page: params[:page], per_page: 10
    render 'list'
  end

  def new
    @activity = Activity.new
    # @activity.users << current_user
    @friends = current_user.friends.load
  end

  def create
    @activity = Activity.new(get_activity_from_params)
    if !@activity.save
      @activity.errors.full_messages.each do |msg| 
        flash[:danger] = msg
      end
      redirect_to new_user_activity_url and return
    end
    flash[:success] = "Noted."
    current_user.add_activity! @activity, params[:activity][:participants]
    redirect_to current_user
  end

  def show
    @activity = Activity.find params[:id]
  end

  private
    def get_activity_from_params
      params[:activity][:participants] = ActiveSupport::JSON.decode params[:activity][:participants]
      params.require(:activity).permit(:event, :location, :amount, :currency, :participants)
    end

end