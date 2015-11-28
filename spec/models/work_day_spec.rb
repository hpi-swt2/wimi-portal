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
      FactoryGirl.build(:work_day, user_id: '1').should_not be_valid
    end

    it 'is invalid without a start_time' do
      FactoryGirl.build(:work_day, start_time: nil).should_not be_valid
    end

    it 'is invalid without a break that is an integer' do
      FactoryGirl.build(:work_day, break: nil).should_not be_valid
      FactoryGirl.build(:work_day, break: '1').should_not be_valid
    end

    it 'is invalid without an end_time' do
      FactoryGirl.build(:work_day, end_time: nil).should_not be_valid
    end

end
