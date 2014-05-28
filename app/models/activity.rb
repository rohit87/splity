class Activity < ActiveRecord::Base

  validates :event, presence: true
  validates :amount, presence: true
  validates_numericality_of :amount, greater_than_or_equal_to: 3
  validates :currency, presence: true

  # has_and_belongs_to_many :users
  has_many :participations
  has_many :users, through: :participations

  before_save {
    self.currency = currency.upcase
  }

  CurrencySymbol = {
    :INR => "&#x20B9;"
  }.freeze

  def save!
    raise "Could not save!" if !self.save
  end

end
