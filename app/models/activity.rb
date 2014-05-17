class Activity < ActiveRecord::Base

  validates :event, presence: true
  validates :amount, presence: true
  validates :currency, presence: true

  before_save {
    self.currency = currency.upcase
  }

end
