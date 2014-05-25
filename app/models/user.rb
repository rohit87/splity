class User < ActiveRecord::Base

  #has_many :friendships, foreign_key: "user_id", dependent: :destroy
  #has_many :reverse_friendships, foreign_key: "friend_id", dependent: :destroy, class_name: "Friendship"

  #has_many :friends, through: :friendships
  has_and_belongs_to_many :friends,
    class_name: "User",
    join_table: "friendships",
    foreign_key: "user_id",
    association_foreign_key: "friend_id"

  # has_and_belongs_to_many :activities
  has_many :participations
  has_many :activities, through: :participations

  has_many :notifications

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

  before_create {
    :create_remember_token
  }

  has_secure_password

  def is_friends_of?(user)
    self.friends.include? user
  end

  def create_friendship!(user)
    self.friends << user
    user.friends << self
  end

  def unfriend!(user)
    self.friends = self.friends - [ user ]
    user.friends = user.friends - [ self ]
  end

  def add_activity!(activity, participations)
    puts participations.inspect

    activity.save!
    participations.each do |participation|
      participation[:activity_id] = activity.id
      Participation.new(participation).save!
    end
    # self.activities << activity
    # friend_ids.each do |friend_id|
    #   activity.users << User.find(friend_id.to_i)
    # end
    # activity.users << self
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end
