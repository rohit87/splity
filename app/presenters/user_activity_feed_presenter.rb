class UserActivityFeedPresenter

  include ActivityQueryHelper

  def initialize(user, query, query_parameters)
    @query = query
    @query_parameters = query_parameters
    @activities = Activity.joins(:participations)
      .where(query)
      .uniq
      .order({ date: :desc, created_at: :desc})
      .map(&-> (activity) {ActivityPresenter.new(activity)})
  end

  def title
    return "Your Activities" if !@query_parameters.present?
    base = "Your Activities "
    if @query_parameters[:names].present?
      base += "with #{@query_parameters[:names].to_sentence} "
    end
    if @query_parameters[:location].present?
      base += "at #{@query_parameters[:location]} "
    end
    if @query_parameters[:date].present?
      base += "on #{@query_parameters[:date]} "
    end
    if @query_parameters[:friend].present?
      base += "with #{User.where({id: @query_parameters[:friend].to_i}).pluck(:name).first} "
    end
    return base
  end

  def activities
    @activities
  end


    private

      attr_reader :query

end