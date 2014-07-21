require 'spec_helper'

describe Activity do
  
  it 'has a valid factory' do
    FactoryGirl.create(:activity).should be_valid
  end

  it 'should be possible to create without any participants' do
    FactoryGirl.create(:activity).should be_valid
  end

  it 'is invalid without numeric amounts' do
    FactoryGirl.build(:activity, amount: "LOL").should_not be_valid
  end

  it 'is invalid without an event' do
    FactoryGirl.build(:activity, event: nil).should_not be_valid
  end

  it 'is invalid without an amount' do
    FactoryGirl.build(:activity, amount: nil).should_not be_valid
  end

  it 'is invalid without an amount greater than 3' do
    FactoryGirl.build(:activity, amount: -1).should_not be_valid
    FactoryGirl.build(:activity, amount: nil).should_not be_valid
    FactoryGirl.build(:activity, amount: 3).should_not be_valid
    FactoryGirl.build(:activity, amount: 13).should be_valid
  end

  it 'is invalid without a currency' do
    FactoryGirl.build(:activity, currency: nil).should_not be_valid
  end

  it 'should only allow 3 letter codes as currencies' do
    FactoryGirl.build(:activity, currency: "").should_not be_valid
    FactoryGirl.build(:activity, currency: "$").should_not be_valid
    FactoryGirl.build(:activity, currency: "Rs").should_not be_valid
    FactoryGirl.build(:activity, currency: "euro").should_not be_valid
    FactoryGirl.build(:activity, currency: "USD").should be_valid
    FactoryGirl.build(:activity, currency: "EUR").should be_valid
    FactoryGirl.build(:activity, currency: "INR").should be_valid
  end

  it 'should upcase currencies while saving' do
    FactoryGirl.create(:activity, currency: "usd").currency.should eq "USD"
  end

end