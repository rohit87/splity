class ActivityPresenter

  include ActionView::Helpers::NumberHelper

  delegate :id, to: :activity
  delegate :event, to: :activity
  delegate :users, to: :activity
  delegate :created_at, to: :activity

  def initialize(activity)
    @activity = activity
  end

  def location
    activity.location
  end

  def date
    Date.parse(activity.created_at.strftime('%Y/%m/%d')).to_formatted_s(:long_ordinal)
  end

  def users_except(user)
    activity.users.where.not(id: user.id).select(:name).to_a.map(&:name).to_sentence
  end

  def formatted_total_amount
    number_to_currency activity.amount, { unit: Activity::CurrencySymbol[activity.currency.to_sym].html_safe }
  end

  private

    attr_reader :activity

end