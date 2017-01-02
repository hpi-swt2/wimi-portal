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
end
