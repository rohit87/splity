require 'spec_helper'

describe Friendship do

  it 'should not exist when a user is created' do
    FactoryGirl.create(:user).friends.length.should eq 0
  end

  it 'should connect 2 unrelated users' do
    user1, user2 = FactoryGirl.create(:user), FactoryGirl.create(:user)
    user1.add_friend!(user2)
    user2.friends.include?(user1).should eq true
    user1.friends.include?(user2).should eq true
  end

  it 'should be bi-directional' do
    user1, user2 = FactoryGirl.create(:user), FactoryGirl.create(:user)
    user1.add_friend!(user2)
    user2.friends.include?(user1).should eq true
    user1.friends.include?(user2).should eq true
  end

  it 'should not connect users more than once' do
    user1, user2 = FactoryGirl.create(:user), FactoryGirl.create(:user)
    user1.add_friend! user2
    user1.add_friend! user2
    user2.add_friend! user1
    user1.friends.length.should eq 1
    user2.friends.length.should eq 1
  end

  it 'should work if created and broken many times' do
    user1, user2 = FactoryGirl.create(:user), FactoryGirl.create(:user)
    4.times do
      user1.add_friend! user2
      user2.unfriend! user1
    end
    user1.add_friend! user2
    user2.friends.include?(user1).should eq true
    user2.friends.length.should eq 1
  end

  it 'should be breakable' do
    user1, user2 = FactoryGirl.create(:user), FactoryGirl.create(:user)
    user1.add_friend! user2
    user1.friends.include?(user2).should eq true
    user1.unfriend! user2
    user1.friends.include?(user2).should eq false
  end

  it 'should be breakable from both directions' do
    user1, user2 = FactoryGirl.create(:user), FactoryGirl.create(:user)
    user1.add_friend! user2
    user1.friends.include?(user2).should eq true
    user2.unfriend! user1
    user1.friends.include?(user2).should eq false
  end

  it 'should work for more than one friend' do
    user1, people = FactoryGirl.create(:user), []
    [*1..4].map { |number| people << FactoryGirl.create(:user) }
    people.each { |person| user1.add_friend! person }
    people.each { |person| person.friends.include?(user1).should eq true }
    user1.friends.length.should eq people.length
  end

  it 'should be bulk breakable' do
    user1, people = FactoryGirl.create(:user), []
    [*1..4].map { |number| people << FactoryGirl.create(:user) }
    people.each { |person| user1.add_friend! person }
    people.each { |person| person.friends.include?(user1).should eq true }
    user1.unfriend_everyone!
    people.each { |person| person.friends.include?(user1).should eq false }
  end

end