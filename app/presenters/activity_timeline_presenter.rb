class ActivityTimelinePresenter

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

  def timeline_title(params)
    return "Your Activities" if !params[:query].present?
    base = "Your Activities "
    if params[:query][:names].present?
      base += "with #{params[:query][:names].to_sentence} "
    end
    if params[:query][:location].present?
      base += "at #{params[:query][:location]} "
    end
    if params[:query][:date].present?
      base += "on #{params[:query][:date]} "
    end
    if params[:query][:friend].present?
      base += "with #{User.where({id: params[:query][:friend].to_i}).pluck(:name).first} "
    end
    return base
  end

end