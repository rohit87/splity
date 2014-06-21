class FeedsController < ApplicationController

  def feed
    @query = feed_params[:query]
    @query_parameters = feed_params[:query_parameters]
    render json: {
      activities: Activity.joins(:participations)
        .where(feed_params[:query])
        .uniq
        .order({ date: :desc, created_at: :desc})
      }
  end

  private

    def feed_params
      params
    end

end