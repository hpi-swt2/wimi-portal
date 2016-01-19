require 'rails_helper'

RSpec.describe TimeSheet, type: :model do
  before(:each) do
  	@sheet = FactoryGirl.create(:time_sheet)
  end

  it 'sums up the right ammount of working hours' do
  	@first_day = FactoryGirl.create(:work_day)
  	@first_day.update(start_time: Time.now, end_time: Time.now + 2.hour, date: Date.tomorrow)
  	@second_day = FactoryGirl.create(:work_day)
  	@second_day.update(start_time: Time.now, end_time: Time.now + 3.hour, date: Date.today) 
  	expect(@sheet.sum_hours).to eq(4) #each work_day includes a 30min break
  end
end