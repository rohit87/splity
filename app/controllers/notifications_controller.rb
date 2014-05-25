class NotificationsController < ApplicationController

  before_action :signed_in_user

  def all_notifications_lightbox
    render partial: "layouts/partials/all_notifications" if current_user.notifications.length > 0
  end

  def read_notification
    Notification.delete params[:notification_id]
    all_notifications_lightbox
  end
  
end