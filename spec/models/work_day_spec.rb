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
    FactoryGirl.create(:work_day).should be_valid
  end

  it 'is invalid without a date' do
    FactoryGirl.build(:work_day, date: nil).should_not be_valid
  end

  it 'is invalid without a user_id that is an integer' do
    FactoryGirl.build(:work_day, user_id: nil).should_not be_valid
    FactoryGirl.build(:work_day, user_id: 'invalid').should_not be_valid
  end

  it 'is invalid without a start_time' do
    FactoryGirl.build(:work_day, start_time: nil).should_not be_valid
  end

  it 'is invalid without a break that is an integer' do
    FactoryGirl.build(:work_day, break: nil).should_not be_valid
    FactoryGirl.build(:work_day, break: 'invalid').should_not be_valid
  end

  it 'is invalid without an end_time' do
    FactoryGirl.build(:work_day, end_time: nil).should_not be_valid
  end

  it 'returns the duration of a work_day' do
    workday = FactoryGirl.create(:work_day) #use the standard values
    expect(workday.duration).to eq(30)
  end
end
