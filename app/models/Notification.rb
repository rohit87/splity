class Notification < ActiveRecord::Base
  belongs_to :user
end

class WelcomeNotification < Notification

  def initialize(user)
    super({})
    # ApplicationController.new.render_to_string(:partial => 'views/notifications/welcome', locals: user)
    self.text = ActionView::Base.new(Rails.configuration.paths["app/views"]).render(
      :partial => 'notifications/welcome',
      :locals => { :user => user }
    )
  end
end