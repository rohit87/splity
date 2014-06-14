class ActivityPresenter

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

  delegate :id, :event, :users, :date, to: :activity
  
  def initialize(activity)
    @activity = activity
  end

  def truncated_event
    truncate(activity.event, separator: ' ')
  end

  def location
    activity.location
  end

  def truncated_location
    truncate(activity.location, separator: ' ')
  end

  def raw_date
    activity.date
  end

  def date
    Date.parse(activity.date.strftime('%Y/%m/%d')).to_formatted_s(:long_ordinal)
  end

  def users_except(user)
    activity.users.where.not(id: user.id) # this is the best
    # User.includes(:activities).where.not(id: user.id).where(activities: { id: id }).pluck(:name).to_sentence
  end

  def formatted_total_amount
    number_to_currency activity.amount, { unit: Activity::CurrencySymbol[activity.currency.to_sym].html_safe }
  end

  private

    attr_reader :activity

end