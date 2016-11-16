# == Schema Information
#
# Table name: time_sheets
#
#  id                       :integer          not null, primary key
#  month                    :integer
#  year                     :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  handed_in                :boolean          default(FALSE)
#  rejection_message        :text             default("")
#  signed                   :boolean          default(FALSE)
#  last_modified            :date
#  status                   :integer          default(0)
#  signer                   :integer
#  wimi_signed              :boolean          default(FALSE)
#  hand_in_date             :date
#  user_signature           :text
#  representative_signature :text
#  user_signed_at           :date
#  representative_signed_at :date
#  contract_id              :integer          not null
#

require 'rails_helper'

RSpec.describe TimeSheet, type: :model do
  before(:each) do
    @sheet = FactoryGirl.create(:time_sheet)
    @contract = @sheet.contract
    @sheet.user.projects << FactoryGirl.create(:project)
    @time1 = Time.parse('10:00:00')
    @time2 = @time1 + 1.hour
    @time3 = @time1 + 2.hours
    @date1 = Date.new(@sheet.year, @sheet.month, 1)
    @date2 = Date.new(@sheet.year, @sheet.month, 10)
  end

  it 'sums up the right ammount of working minutes' do
    FactoryGirl.create(:work_day, date: @date1, start_time: @time1, end_time: @time2, time_sheet: @sheet)
    FactoryGirl.create(:work_day, date: @date2, start_time: @time2, end_time: @time3, time_sheet: @sheet)
    # Using '-' on Time  objects results in the difference in seconds
    expect(@sheet.sum_minutes).to eq((@time3-@time1)/1.minute)
  end

  it 'sums up the right ammount of working hours' do
    FactoryGirl.create(:work_day, date: @date1, start_time: @time1, end_time: @time2, time_sheet: @sheet)
    FactoryGirl.create(:work_day, date: @date2, start_time: @time2, end_time: @time3, time_sheet: @sheet)
    expect(@sheet.sum_hours).to eq((@time3-@time1)/1.hour)
  end

  it 'generates the right amount of work days' do
    @sheet.generate_work_days
    expect(@sheet.work_days.size).to eq(Time.days_in_month(@sheet.month,@sheet.year))
    # make sure all the days are different
    num_eq = 0
    @sheet.work_days.each do |wd1|
      @sheet.work_days.each do |wd2|
        if wd1.date == wd2.date
          num_eq+=1
        end
      end
    end
    expect(num_eq).to eq(@sheet.work_days.size)
  end

  it 'fills in missing work days' do
    @sheet.work_days.build(date: @date1, start_time: @time1, end_time: @time1)
    @sheet.work_days.build(date: @date2, start_time: @time2, end_time: @time3)

    expect(@sheet.work_days.size).to eq(2)

    @sheet.generate_missing_work_days

    expect(@sheet.work_days.size).to eq(Time.days_in_month(@sheet.month,@sheet.year))
    # make sure all the days are different
    num_eq = 0
    @sheet.work_days.each do |wd1|
      @sheet.work_days.each do |wd2|
        if wd1.date == wd2.date
          num_eq+=1
        end
      end
    end
    expect(num_eq).to eq(@sheet.work_days.size)
  end

  it 'determines if a work day has comments' do
    workday1 = FactoryGirl.create(:work_day, time_sheet: @sheet, notes: '')
    workday2 = FactoryGirl.create(:work_day, time_sheet: @sheet, notes: 'Lorem')

    expect(@sheet).to have_comments
  end

  context 'containsDate' do
    it 'returns true if the date lies within the month/year' do
      date = Date.today
      expect(@sheet.containsDate(date)).to be true
    end

    it 'returns false if the date lies outside the month/year' do
      date = Date.today >> 1 # 1 month after the current Date
      expect(@sheet.containsDate(date)).to be false
    end

    it 'takes the year into account' do
      date = Date.today >> 12 # 1 year after the current date
      expect(@sheet.containsDate(date)).to be false
    end
  end
end
