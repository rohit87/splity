class FacebookFriendsImporter
  @queue = :users_queue

  def self.perform(user_id)
    user = User.find user_id
    user.import_facebook_friends!
  end
end