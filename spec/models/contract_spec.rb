# == Schema Information
#
# Table name: contracts
#
#  id             :integer          not null, primary key
#  start_date     :date
#  end_date       :date
#  chair_id       :integer
#  user_id        :integer
#  hiwi_id        :integer
#  responsible_id :integer
#  flexible       :boolean
#  hours_per_week :integer
#  wage_per_hour  :decimal(5, 2)
#

require 'rails_helper'

RSpec.describe Contract, type: :model do

  context "scope for_user_in_month" do
    before(:each) do
      @sheet = FactoryGirl.create(:time_sheet)
      @user = @sheet.user
      @contract = @sheet.contract
    end

    it 'returns all contracts of a user in a given month and year' do
      contract1 = FactoryGirl.create(:contract, start_date: Date.new(2016,1), end_date: Date.new(2016,3,15), hiwi: @user)
      contract1 = FactoryGirl.create(:contract, start_date: Date.new(2016,3, 15), end_date: Date.new(2016,4), hiwi: @user)

      query = Contract.for_user_in_month(@user, 3, 2016)
      expect(query.size).to eq(2)
    end
  end

  context "deletion" do
    before(:each) do
      @hiwi = FactoryGirl.create(:hiwi)
      start_date = Date.today << 1
      end_date = Date.today >> 5
      @contract = FactoryGirl.create(:contract, hiwi: @hiwi, start_date: start_date, end_date: end_date)
    end

    it 'is possible when a contract has no time_sheets' do
      expect { @contract.destroy }.to change { Contract.count }.from(1).to(0)
    end

    it 'also deletes all of a contract\'s time sheets' do
      @time_sheet = FactoryGirl.create(:time_sheet, contract: @contract, month: @contract.start_date.month, year: @contract.start_date.year)
      expect(@contract.time_sheets.count).to eq(1)
      expect { @contract.destroy }.to change { TimeSheet.count }.from(1).to(0)
      expect(Contract.count).to eq(0)
    end
  end

  context "calculating the amount of hours that need to be worked to fulfill the contract" do
    before(:each) do
      @contract = FactoryGirl.build(:contract, flexible: false, hours_per_week: 9)
      @flexible_contract = FactoryGirl.build(:contract, flexible: true)
    end

    it "returns monthly hours for normal contracts" do
      expect(@contract.monthly_work_hours).to eq(@contract.hours_per_week * Contract::WEEKS_PER_MONTH)
    end

    it "returns monthly minutes for normal contracts" do
      expect(@contract.monthly_work_minutes).to eq(@contract.monthly_work_hours*60)
    end

    it "returns nil for flexible contracts" do
      expect(@flexible_contract.monthly_work_hours).to be nil
      expect(@flexible_contract.monthly_work_minutes).to be nil
    end
  end

  context "listing time sheets, including missing ones" do
    before(:each) do
      @month_duration = 3
      @start_date = Date.today.beginning_of_month
      @end_date = (@start_date + @month_duration.months - 1).end_of_month
      @contract = FactoryGirl.create(:contract, start_date: @start_date, end_date: @end_date)
    end

    it "returns unsaved time sheets when no time sheets are present" do
      expect(@contract.time_sheets_including_missing.size).to eq(@month_duration)
      all_new = @contract.time_sheets_including_missing.all? { |ts| ts.new_record? }
      expect(all_new).to be true
    end

    it "returns single saved time sheet when time sheet is present in first contract month" do
      ts = FactoryGirl.create(:time_sheet, contract: @contract, month: @start_date.month, year: @start_date.year)
      expect(@contract.time_sheets_including_missing.size).to eq(@month_duration)
      saved = @contract.time_sheets_including_missing.select { |ts| ts.persisted? }
      expect(saved.size).to eq(1)
      expect(saved.first).to eq(ts)
    end
    
    it "returns single saved time sheet when time sheet is present in last contract month" do
      ts = FactoryGirl.create(:time_sheet, contract: @contract, month: @end_date.month, year: @end_date.year)
      expect(@contract.time_sheets_including_missing.size).to eq(@month_duration)
      saved = @contract.time_sheets_including_missing.select { |ts| ts.persisted? }
      expect(saved.size).to eq(1)
      expect(saved.first).to eq(ts)
    end

    it "returns missing months when time sheet is present in middle contract month" do
      date = @contract.start_date + 1.month + 1.day
      ts = FactoryGirl.create(:time_sheet, contract: @contract, month: date.month, year: date.year)
      expect(@contract.time_sheets_including_missing.size).to eq(@month_duration)
      saved = @contract.time_sheets_including_missing.select { |ts| ts.persisted? }
      expect(saved.size).to eq(1)
      expect(saved.first).to eq(ts)
    end

    it "returns missing months up to a specified date when time sheet is present" do
      date = @contract.start_date + 1.month + 1.day
      ts = FactoryGirl.create(:time_sheet, contract: @contract, month: date.month, year: date.year)
      expect(@contract.time_sheets_including_missing(date).size).to eq(@month_duration - 1)
      saved = @contract.time_sheets_including_missing(date).select { |ts| ts.persisted? }
      expect(saved.size).to eq(1)
      expect(saved.first).to eq(ts)
    end

    it "returns missing months up to a specified date, but none after contract end" do
      date_after_contract_end = @end_date+3.months
      expect(@contract.time_sheets_including_missing(date_after_contract_end).size).to eq(@month_duration)
    end
  end

  context 'missing timesheets' do
    before :each do
      @start_date = Date.today.at_beginning_of_month << 2
      @end_date = Date.today >> 1
      @contract = FactoryGirl.create(:contract, start_date: @start_date, end_date: @end_date)
    end

    context 'without any timesheets' do
      it 'includes all months prior to the current month' do
        @dates = @contract.missing_timesheets
        expect(@dates).to contain_exactly(@start_date, @start_date >> 1)
      end

      context 'and a contract that has a start date within the last month' do
        before :each do
          @contract.update(start_date: Date.today.end_of_month << 1)
          @contract.reload
        end
        it 'includes the first day of the last month' do
          @dates = @contract.missing_timesheets
          expect(@dates).to contain_exactly(Date.today.at_beginning_of_month << 1)
        end
      end
    end
  end
end
