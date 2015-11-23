require 'rails_helper'

RSpec.describe Holiday, type: :model do
  before(:each) do
  	 @user = FactoryGirl.create(:user)
     #sign_in @user
     #@user.save!
  end

  it "has a valid factory" do
  	expect(FactoryGirl.create(:holiday, user_id: @user.id)).to be_valid
  end

  it "is invalid without a user" do
    expect(FactoryGirl.build(:holiday, user_id: nil)).to_not be_valid
  end

  it "is invalid when end is before start" do
    expect(FactoryGirl.build(:holiday, user_id: @user.id, end: Date.yesterday)).to_not be_valid
  end

  it "is invalid when start is before today" do
  	expect(FactoryGirl.build(:holiday, user_id: @user.id, start: Date.yesterday)).to_not be_valid
  end

  it "is invalid when to far in the future" do
    expect(FactoryGirl.build(:holiday, user_id: @user.id, start: Date.new(Date.today.year + 2, 1, 1), end: Date.new(Date.today.year+2, 1, 2))).to_not be_valid
  end

  it "is invalid when not enough leave is left for this year" do
    @user.update_attribute(:remaining_leave_this_year, 0)
    expect(FactoryGirl.build(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: Date.new(Date.today.year + 1, 1,1))).to_not be_valid
  end

  it "is invalid when not enough leave is left for next year" do
    expect(FactoryGirl.build(:holiday, user_id: @user.id, start: Date.new(Date.today.year + 1, 1, 1), end: Date.new(Date.today.year + 1, 12, 31))).to_not be_valid
  end

  it "returns the duration for this year" do
    holiday = FactoryGirl.create(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: Date.new(Date.today.year + 1, 1, 1))
    expect(holiday.duration_this_year).to eq(1)
  end

  it "returns the duration for next year" do
    holiday = FactoryGirl.create(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: Date.new(Date.today.year + 1, 1, 1))
    expect(holiday.duration_next_year).to eq(1)
  end

#  it "subtracts the right amount of leave for this year" do
#    @leave_left_this_year = @user.remaining_leave_this_year
#    @holiday = FactoryGirl.create(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: Date.new(Date.today.year + 1, 1, 1))
#    @user.remaining_leave_this_year -= @holiday.duration_this_year
#    @user.remaining_leave_this_year.should == (@leave_left_this_year - 1)
#  end

#  it "subtracts the right amount of leave for next year" do
#    @leave_left_next_year = @user.remaining_leave_next_year
#    FactoryGirl.create(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: Date.new(Date.today.year + 1, 1, 1))
#    @user.remaining_leave_next_year.should == (@leave_left_next_year - 1)
#  end

#  it "refunds the duration for this year" do
#    @leave_left_this_year = @user.remaining_leave_this_year
#    @holiday = FactoryGirl.create(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: Date.new(Date.today.year + 1, 1, 1))
#    @holiday.destroy
#    @user.remaining_leave_this_year.should == @leave_left_this_year
#  end

# it "refunds the duration for next year" do
#    @leave_left_next_year = @user.remaining_leave_next_year
#    @holiday = FactoryGirl.create(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: Date.new(Date.today.year + 1, 1, 1))
#    @user.remaining_leave_next_year.should == (@leave_left_next_year-1)
#    @holiday.destroy
#    @user.remaining_leave_next_year.should == @leave_left_next_year
#  end
end
