require 'rails_helper'
require 'spec_helper'

describe WorkDay, type: :model do

    it 'has a valid factory' do
      expect(FactoryGirl.create(:work_day)).to be_valid
    end

    it 'is invalid without a date' do
      expect(FactoryGirl.build(:work_day, date: nil)).not_to be_valid
    end

    it 'is invalid without a user_id that is an integer' do
      expect(FactoryGirl.build(:work_day, user_id: nil)).not_to be_valid
      expect(FactoryGirl.build(:work_day, user_id: 'invalid')).not_to be_valid
    end

    it 'is invalid without a start_time' do
      expect(FactoryGirl.build(:work_day, start_time: nil)).not_to be_valid
    end

    it 'is invalid without a break that is an integer' do
      expect(FactoryGirl.build(:work_day, break: nil)).not_to be_valid
      expect(FactoryGirl.build(:work_day, break: 'invalid')).not_to be_valid
    end

    it 'is invalid without an end_time' do
      expect(FactoryGirl.build(:work_day, end_time: nil)).not_to be_valid
    end

    it 'returns the duration of a work_day' do
      workday = FactoryGirl.create(:work_day) #use the standard values
      expect(workday.duration).to eq(30)
    end

end
