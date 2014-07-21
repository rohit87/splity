require 'faker'

FactoryGirl.define do
  factory :user do |u|
    u.name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    u.email { Faker::Internet.email }
    u.password { Faker::Internet.password(10) }
  end
end