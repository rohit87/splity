class User < ActiveRecord::Base

  #has_many :friendships, foreign_key: "user_id", dependent: :destroy
  #has_many :reverse_friendships, foreign_key: "friend_id", dependent: :destroy, class_name: "Friendship"

  # Friends
  # TODO: Convert this to a has_many :through
  has_and_belongs_to_many :friends,
    class_name: "User",
    join_table: "friendships",
    foreign_key: "user_id",
    association_foreign_key: "friend_id"

  # Activities
  has_many :participations, dependent: :destroy
  has_many :activities, through: :participations, dependent: :destroy

  # Notifications
  has_many :notifications, dependent: :destroy

  # has_many :friends, through: :reverse_friendships
  

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, {
    presence: true,
    format: {
      with: VALID_EMAIL_REGEX
    },
    uniqueness: true
  }

  validates :name, {
    presence: true,
    length: {
      maximum: 50,
      minimum: 5
    }
  }
  
  validates :password, {
    length: {
      minimum: 6,
      maximum: 30
    }
  }

  before_save {
    self.email = email.downcase
  }

  before_create :create_remember_token

  before_destroy :unfriend_everyone!

  has_secure_password

  def self.create_or_update_user(user)
    is_new_user = user.new_record?
    if user.save!
      if is_new_user 
        user.notifications << WelcomeNotification.new(user)
        UserMailer.welcome_email(user).deliver
        Resque.enqueue(FacebookFriendsImporter, user.id) if user.is_facebook_user?
      end
      return true
    else
      return false
    end
  end

  def self.from_omniauth(auth)
    User.where(email: auth.info.email, provider: auth.provider, external_user_id: auth.uid).first_or_initialize.tap do |user|
      puts user.to_json
      user.external_user_id = auth.uid
      user.email = auth.info.email
      user.name = "#{auth.info.first_name} #{auth.info.last_name}"
      user.password = auth.credentials.token[0..29]
      user.auth_token = auth.credentials.token
      user.remember_token = auth.credentials.token
      user.image_url = auth.info.image
      return user
    end
  end

  def patch(field, value)
    validation_result = validate_attribute field, value
    self.update_attribute(field, value) if validation_result[:valid]
    validation_result
  end

  def is_friends_of?(user)
    self.friends.include? user
  end

  def create_friendship!(user)
    user.transaction do
      self.friends << user
      user.friends << self
    end
  end

  def unfriend!(user)
    self.friends = self.friends - [ user ]
    user.friends = user.friends - [ self ]
  end

  def unfriend_everyone!
    self.transaction do
      self.friends.each do |friend|
        self.unfriend! friend
      end
    end
  end

  def add_activity!(activity, participations)
    activity.save!
    participations.each do |participation|
      participation[:activity_id] = activity.id
      Participation.new(participation).save!
    end
  end

  def activities_with(*users)
    Activity.includes(:users).where(users: { id: users.map(&:id) }).order({ date: :desc })
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # Typeof user
  def is_facebook_user?
    self.provider == "facebook"
  end

  # facebook
  def import_facebook_friends!
    @graph = Koala::Facebook::API.new(self.auth_token)
    @friends = @graph.get_connections("me", "friends", api_version: "v2.0")
    @friends.each do |friend|
      begin
        self.create_friendship! User.find_by_external_user_id friend["id"]
      rescue
        puts "error creating friendship!"
      end
    end
  end

  private

    def create_remember_token
      if self.is_facebook_user?
        self.remember_token = self.auth_token
      else
        self.remember_token = User.digest(User.new_remember_token)
      end
    end

    def validate_attribute(attr, value)
      mock = User.new(attr => value)
      if !mock.valid?
        return {
          valid: !mock.errors.has_key?(attr),
          errors: mock.errors.full_messages_for(attr)
        }
      end
      return {
        valid: true,
        errors: []
      }
    end

end
