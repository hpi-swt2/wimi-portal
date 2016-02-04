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
