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
  before(:each) do
    @sheet = FactoryGirl.create(:time_sheet)
    @user = @sheet.user
    @contract = @sheet.contract
  end

  context("scope for_user_in_month") do
    it 'returns all contracts of a user in a given month and year' do
      contract1 = FactoryGirl.create(:contract, start_date: Date.new(2016,1), end_date: Date.new(2016,3,15), hiwi: @user)
      contract1 = FactoryGirl.create(:contract, start_date: Date.new(2016,3, 15), end_date: Date.new(2016,4), hiwi: @user)

      query = Contract.for_user_in_month(@user, 3, 2016)
      expect(query.size).to eq(2)
    end
  end
end
