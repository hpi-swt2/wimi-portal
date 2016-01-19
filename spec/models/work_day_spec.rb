# == Schema Information
#
# Table name: work_days
#
#  id         :integer          not null, primary key
#  date       :date
#  start_time :time
#  break      :integer
#  end_time   :time
#  attendance :string
#  notes      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  project_id :integer
#

require 'rails_helper'
require 'spec_helper'

describe WorkDay, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:work_day)).to be_valid
  end

  it 'is invalid without a date' do
    expect(FactoryGirl.build(:work_day, date: nil)).to_not be_valid
  end

  it 'is invalid without a user_id that is an integer' do
    expect(FactoryGirl.build(:work_day, user_id: nil)).to_not be_valid
    expect(FactoryGirl.build(:work_day, user_id: 'invalid')).to_not be_valid
  end

  it 'is invalid without a start_time' do
    expect(FactoryGirl.build(:work_day, start_time: nil)).to_not be_valid
  end

  it 'is invalid without a break that is an integer' do
    expect(FactoryGirl.build(:work_day, break: nil)).to_not be_valid
    expect(FactoryGirl.build(:work_day, break: 'invalid')).to_not be_valid
  end

  it 'is invalid without an end_time' do
    expect(FactoryGirl.build(:work_day, end_time: nil)).to_not be_valid
  end

  it 'is invalid with end bevor start' do
    expect(FactoryGirl.build(:work_day, end_time: Time.now.beginning_of_day, start_time: Time.now.end_of_day)).to_not be_valid
  end

  it 'is invalid with a negative duration' do
    expect(FactoryGirl.build(:work_day, break: 180))
  end

  it 'returns the duration of a work_day' do
    workday = FactoryGirl.create(:work_day) 
    expect(workday.duration).to eq(1.5)
  end
end
