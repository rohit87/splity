require 'faker'

FactoryGirl.define do
  factory :activity do |a|
    a.event { Faker::Commerce.department }
    a.location { "#{Faker::Address.street_address} #{Faker::Address.street_name} #{Faker::Address.city}" }
    a.currency { "USD" }
    a.amount { rand(10000) }
  end
end