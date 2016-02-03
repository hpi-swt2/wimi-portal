# == Schema Information
#
# Table name: expenses
#
#  id               :integer          not null, primary key
#  inland           :boolean
#  country          :string
#  location_from    :string
#  location_via     :string
#  reason           :text
#  car              :boolean
#  public_transport :boolean
#  vehicle_advance  :boolean
#  hotel            :boolean
#  status           :integer          default(0)
#  general_advance  :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  signature        :boolean
#  trip_id          :integer
#  time_start       :string
#  time_end         :string
#

require 'rails_helper'

RSpec.describe Expense, type: :model do
  before :each do
    @report = FactoryGirl.create(:expense, user: FactoryGirl.create(:user))
  end

  context 'with valid input' do
    it 'creates a valid report' do
      expect(Expense.first).to eq(@report)
    end
    it 'has access to name of the user' do
      expect(@report.first_name).to eq(User.first.first_name)
      expect(@report.last_name).to eq(User.first.last_name)
    end
  end

  context 'with invalid input' do
    it 'rejects negative advances' do
      expect(FactoryGirl.build(:expense_negative_advance).valid?).to be false
    end
  end
end
