require 'spec_helper' 

describe User do 

  # Basic Validations
  # These should never fail
  it "has a valid factory" do
    FactoryGirl.create(:user).should be_valid
  end
  
  it 'is invalid without an email' do
    FactoryGirl.build(:user, email: nil).should_not be_valid
  end

  it 'is invalid without a password' do
    FactoryGirl.build(:user, password: nil).should_not be_valid
  end

  it 'is invalid without a password longer that 6 characters' do
    FactoryGirl.build(:user, password: "123").should_not be_valid
  end

  it 'is invalid with a password greater than 30 characters' do
    FactoryGirl.build(:user, password: "123456123456123456123456123456123456").should_not be_valid
  end


  # Email uniqueness
  it 'should always have a unique email' do
    user = FactoryGirl.create(:user)
    FactoryGirl.build(:user, email: user.email).should_not be_valid
  end

  # Remember token basics
  it 'should always have a remember token after being saved' do
    FactoryGirl.create(:user).remember_token.should_not be_nil
  end

  it 'should not have any friends when created' do
    FactoryGirl.create(:user).friends.length.should eq 0
  end

  it 'should not have any activities when created' do
    FactoryGirl.create(:user).activities.length.should eq 0
  end

  


end