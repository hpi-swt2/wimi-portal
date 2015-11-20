require 'rails_helper'

RSpec.describe Holiday, type: :model do
  before(:each) do
  	 @user = FactoryGirl.create(:user)
  end

  it "has a valid factory" do
  	#@user = FactoryGirl.create(:user)
  	FactoryGirl.create(:holiday, user_id: @user.id).should be_valid
  end

  it "is invalid without a user" do
    FactoryGirl.build(:holiday, user_id: nil).should_not be_valid
  end

  it "is invalid when end is before start" do
  	#@user = FactoryGirl.create(:user)
    FactoryGirl.build(:holiday, user_id: @user.id, end: Date.yesterday).should_not be_valid
  end
  it "is invalid when start is before today" do
  	FactoryGirl.build(:holiday, user_id: @user.id, start: Date.yesterday).should_not be_valid
  end

  it "returns the duration from start to end" do
    @holiday = FactoryGirl.create(:holiday, user_id: @user.id)
    @holiday.duration.should == 1
  end
end
