class UserActivityFeedPresenter

  def initialize(user)
    @activities = user.activities.order({ date: :desc, created_at: :desc}).map(&-> (activity) {ActivityPresenter.new(activity)})
  end

  def activities
    @activities
  end

end