class ActivitiesController < ApplicationController

  require 'date'

  before_action :signed_in_user, except: [:create]
  protect_from_forgery :except => [:create]

  def index
    query = { }
    user_ids = []
    user_ids << current_user.id

    if params[:query]
      for key in params[:query].keys
        case key
        when "date"
          query[key] = Date.parse(params[:query][key])
        when "friend"
          poorly_written_query = {
            participations: {
              activity_id: User.find(params[:query][:friend]).activities.pluck(:id)
            }
          }
        else
          query[key] = params[:query][key]
        end
      end
    end

    # @activities = Activity.includes(:users).where(users: { id: user_ids }).where(query).order({ date: :desc }).paginate(page: params[:page], per_page: 10)
    # @activities = current_user.activities.where(query).where({ activitys: { participations: { id: 4 } } }).order({ created_at: :desc }).paginate(page: params[:page], per_page: 10)
    @activities = Activity.joins(:participations)
      .where(poorly_written_query)
      .where(query)
      .uniq
      .order({ created_at: :desc })
      .paginate(page: params[:page], per_page: 10)
    # binding.pry
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