class ActivitiesController < ApplicationController

  require 'date'

  include ActivityQueryHelper  

  before_action :signed_in_user, except: [:create]
  protect_from_forgery :except => [:create]

  def index
    @activities = Activity.joins(:participations)
      .where(get_activities_query_from_params)
      .uniq
      .order({ created_at: :desc })
      .paginate(page: params[:page], per_page: 10)
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
    current_user.add_activity! @activity, sanitized_participants
    redirect_to current_user
  end

  def show
    @activity = Activity.find params[:id]
  end

  private
    def get_activity_from_params
      params[:activity][:participants] = JSON.parse params[:activity][:participants]
      params.require(:activity).permit(:event, :location, :amount, :currency, :date)
    end

    def sanitized_participants
      participants = []
      params[:activity][:participants].each do |participation|
        participants << participation.permit(:user_id, :amount_paid, :activity_id, :amount_owed, :amount_owed_to)
      end
      participants
    end

end