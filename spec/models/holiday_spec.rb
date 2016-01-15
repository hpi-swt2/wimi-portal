# == Schema Information
#
# Table name: holidays
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start      :date
#  end        :date
#  status     :integer          default(0)
#

require 'rails_helper'

RSpec.describe Holiday, type: :model do
  before(:each) do
    @user = FactoryGirl.create(:user)
    #sign_in @user
    #@user.save!
  end

  it 'has a valid factory' do
    expect(FactoryGirl.create(:holiday, user_id: @user.id)).to be_valid
  end

  it 'is invalid without a user' do
    expect(FactoryGirl.build(:holiday, user_id: nil)).to_not be_valid
  end

  it 'is invalid when a wrong date is entered' do
    expect(FactoryGirl.build(:holiday, user_id: @user.id, start: Date.today - 1, end: Date.today)).to_not be_valid
  end

  it 'is invalid when end is before start' do
    expect(FactoryGirl.build(:holiday, user_id: @user.id, end: Date.yesterday)).to_not be_valid
  end

  it 'is invalid when start is before today' do
    expect(FactoryGirl.build(:holiday, user_id: @user.id, start: Date.yesterday)).to_not be_valid
  end

  it 'is invalid when to far in the future' do
    expect(FactoryGirl.build(:holiday, user_id: @user.id, start: Date.new(Date.today.year + 2, 1, 1), end: Date.new(Date.today.year + 2, 1, 2))).to_not be_valid
  end

  it 'is invalid when not enough leave is left' do
    @user.update_attribute(:remaining_leave, 0)
    #if Jan 2nd isn't a business day this test would fail otherwise
    startdate = Date.new(Date.today.year, 12, 31)
    if startdate.wday == 6 || startdate.wday == 0
      startdate -= 1.days until startdate.wday == 5
    end

    enddate = Date.new(Date.today.year + 1, 1, 2)
    if enddate.wday == 6 || enddate.wday == 0
      enddate += 1.days until enddate.wday == 1
    end

    expect(FactoryGirl.build(:holiday, user_id: @user.id, start: Date.new(Date.today.year, 12, 31), end: enddate)).to_not be_valid
  end

  it 'returns the duration' do
    #if Jan 2nd isn't a business day this test would fail otherwise
    startdate = Date.new(Date.today.year, 12, 31)
    if startdate.wday == 6 || startdate.wday == 0
      startdate -= 1.days until startdate.wday == 5
    end

    enddate = Date.new(Date.today.year + 1, 1, 2)
    if enddate.wday == 6 || enddate.wday == 0
      enddate += 1.days until enddate.wday == 1
    end

    holiday = FactoryGirl.create(:holiday, user_id: @user.id, start: startdate, end: enddate)
    expect(holiday.duration).to eq(2)
  end
end
