require 'rails_helper'

RSpec.describe Holiday, type: :model do
  before(:each) do
  	 @user = FactoryGirl.create(:user)
  end

  it "has a valid factory" do
  	FactoryGirl.create(:holiday, user_id: @user.id).should be_valid
  end

  it "is invalid without a user" do
    FactoryGirl.build(:holiday, user_id: nil).should_not be_valid
  end

  it "is invalid when end is before start" do
    FactoryGirl.build(:holiday, user_id: @user.id, end: Date.yesterday).should_not be_valid
  end

  it "is invalid when start is before today" do
  	FactoryGirl.build(:holiday, user_id: @user.id, start: Date.yesterday).should_not be_valid
  end

  it "is invalid when to far in the future" do
    FactoryGirl.build(:holiday, user_id: @user.id, start: Date.new(Date.today.year + 2, 1, 1)).should_not be_valid
  end

  it "is invalid when not enough leave is left for this year" do
    @user.update_attribute(:remaining_leave_this_year, 0)
    FactoryGirl.build(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: Date.new(Date.today.year + 1, 1,1)).should_not be_valid
  end

  it "is invalid when not enough leave is left for next year" do
    FactoryGirl.build(:holiday, user_id: @user.id, start: Date.new(Date.today.year + 1, 1, 1), end: Date.new(Date.today.year + 1, 12, 31)).should_not be_valid
  end

  it "returns the duration for this year" do
    @holiday = FactoryGirl.create(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: Date.new(Date.today.year + 1, 1, 1))
    @holiday.duration_this_year.should == 1
  end

  it "returns the duration for next year" do
    @holiday = FactoryGirl.create(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: Date.new(Date.today.year + 1, 1, 1))
    @holiday.duration_next_year.should == 1
  end

  it "subtracts the right amount of leave for this year" do
    @leave_left_this_year = @user.remaining_leave_this_year
    @holiday = FactoryGirl.create(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: Date.new(Date.today.year + 1, 1, 1))
    @user.remaining_leave_this_year.should == (@leave_left_this_year - 1)
  end

  it "subtracts the right amount of leave for next year" do
    @leave_left_next_year = @user.remaining_leave_next_year
    @holiday = FactoryGirl.create(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: Date.new(Date.today.year + 1, 1, 1))
    @user.remaining_leave_next_year.should == (@leave_left_next_year - 1)
  end

  it "refunds the duraton for this year" do
    @leave_left_this_year = @user.remaining_leave_this_year
    @holiday = FactoryGirl.create(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: Date.new(Date.today.year + 1, 1, 1))
    @holiday.destroy
    @user.remaining_leave_this_year.should == @leave_left_this_year
  end

 it "refunds the duraton for next year" do
    @leave_left_next_year = @user.remaining_leave_next_year
    @holiday = FactoryGirl.create(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: Date.new(Date.today.year + 1, 1, 1))
    @holiday.destroy
    @user.remaining_leave_next_year.should == @leave_left_next_year
  end
end
