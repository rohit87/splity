class ActivitiesController < ApplicationController

  def index
  end

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activities_params)
    if @activity.save
      flash[:success] = "Noted."
      redirect_to current_user
    else
      render 'new'
    end
  end

  def show
  end

  private
    def activities_params
      params.require(:activity).permit(:event, :location, :amount, :currency)
    end

end