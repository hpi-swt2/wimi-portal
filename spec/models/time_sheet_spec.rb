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
    @user = @sheet.user
    @sheet.user.projects << FactoryGirl.create(:project)
    @time1 = Time.parse('10:00:00')
    @time2 = @time1 + 1.hour
    @time3 = @time1 + 2.hours
    @date1 = Date.new(@sheet.year, @sheet.month, 1)
    @date2 = Date.new(@sheet.year, @sheet.month, 10)
  end

  it 'doesn\'t allow creation for months before beginning of contract' do
    # user has a single current contract
    current_contract = @user.current_contracts
    expect(current_contract.length).to eq(1)
    current_contract = current_contract.first
    no_contract_date = (current_contract.start_date + 1.month).end_of_month

    time_sheet = FactoryGirl.build(:time_sheet,
      contract: current_contract,
      month: no_contract_date.month,
      year: no_contract_date.year)

    expect(time_sheet).to_not be_valid
  end

  it 'doesn\'t allow creation for months after end of contract' do
    current_contract = @user.current_contracts.first
    no_contract_date = (current_contract.start_date - 1.month).beginning_of_month

    time_sheet = FactoryGirl.build(:time_sheet,
      contract: current_contract,
      month: no_contract_date.month,
      year: no_contract_date.year)

    expect(time_sheet).to_not be_valid
  end

  context 'creation with contract checking' do
    before(:each) do
      start_date = Date.new(2000,12).beginning_of_month
      end_date = Date.new(2000,12).end_of_month
      @contract = FactoryGirl.create(:contract, start_date: start_date, end_date: end_date)
    end

    it 'is possible for the start month of a contract' do
      time_sheet_start = FactoryGirl.create(:time_sheet, contract: @contract,
        month: @contract.start_date.month, year: @contract.start_date.year)
      expect(time_sheet_start).to be_valid
    end

    it 'is possible for the end month of a contract' do
      time_sheet_end = FactoryGirl.create(:time_sheet, contract: @contract,
        month: @contract.end_date.month, year: @contract.end_date.year)
      expect(time_sheet_end).to be_valid
    end
  end # context 'creation with contract checking'

  it 'is possible to delete a time sheet without work days' do
    expect { @sheet.destroy }.to change { TimeSheet.count }.from(1).to(0)
  end

  context "with connected work days" do
    before(:each) do
      FactoryGirl.create(:work_day, date: @date1, start_time: @time1, end_time: @time2, time_sheet: @sheet)
      FactoryGirl.create(:work_day, date: @date2, start_time: @time2, end_time: @time3, time_sheet: @sheet)
    end

    it 'deleting a time sheet also deletes all of its work days' do
      expect(@sheet.work_days.count).to eq(2)
      expect { @sheet.destroy }.to change { WorkDay.count }.from(2).to(0)
    end

    it 'sums up the right amount of working minutes' do
      # Using '-' on Time  objects results in the difference in seconds
      expect(@sheet.sum_minutes).to eq((@time3-@time1)/1.minute)
    end

    it 'sums up the right ammount of working hours' do
      expect(@sheet.sum_hours).to eq((@time3-@time1)/1.hour)
    end

    it 'determines if a work day has comments' do
      FactoryGirl.create(:work_day, time_sheet: @sheet, notes: '')
      FactoryGirl.create(:work_day, time_sheet: @sheet, notes: 'Lorem')
      expect(@sheet).to have_comments
    end
  end

  it 'allows calling #monthly_work_minutes on time sheets, delegating to contract' do
    expect(@sheet.monthly_work_minutes).to eq(@sheet.contract.monthly_work_minutes)
  end

  it 'returns the percentage (range 0-100) of hours required by the contract' do
    expect(@sheet.percentage_hours_worked).to eq(0)
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

  context 'containsDate' do
    it 'returns true if the date lies within the month/year' do
      date = Date.today
      expect(@sheet.containsDate(date)).to be true
    end

    it 'returns false if the date lies outside the month/year' do
      date = Date.today + 1.month # 1 month after the current Date
      expect(@sheet.containsDate(date)).to be false
    end

    it 'takes the year into account' do
      date = Date.today + 1.year # 1 year after the current date
      expect(@sheet.containsDate(date)).to be false
    end
  end

  context 'same-month validation' do
    it 'returns false when an identical time sheet exists' do
      duplicate = FactoryGirl.build(:time_sheet, month: @sheet.month, year: @sheet.year, contract: @sheet.contract)

      expect(duplicate).not_to be_valid
    end

    it 'returns true when the time sheet is unique' do
      unique = FactoryGirl.create(:time_sheet)

      expect(unique).to be_valid
    end

    it 'returns true when updating a time sheet' do
      result = @sheet.update({})

      expect(result).to be true
    end
  end

  context 'Events are created on' do
    it 'hand in' do
      @sheet.hand_in(@user)

      expect(Event.all.count).to eq(1)
      expect(Event.first.type).to eq('time_sheet_hand_in')
    end

    it 'accept' do
      @sheet.accept_as(@sheet.contract.responsible)

      expect(Event.all.count).to eq(1)
      expect(Event.first.type).to eq('time_sheet_accept')
    end

    it 'decline' do
      @sheet.reject_as(@sheet.contract.responsible)

      expect(Event.all.count).to eq(1)
      expect(Event.first.type).to eq('time_sheet_decline')
    end
  end
end
