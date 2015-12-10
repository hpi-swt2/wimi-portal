require 'rails_helper'

RSpec.describe TravelExpenseReport, type: :model do
  before :each do
    @Hasso = FactoryGirl.create(:travel_expense_report)
  end

  context "with valid input" do
    it "creates a valid report" do
      expect(TravelExpenseReport.first).to eq(@Hasso)
    end
  end

  context "with invalid input" do
    it "rejects blank names" do
      expect(FactoryGirl.build(:travel_expense_report_blank_name).valid?).to be false
    end
    it "rejects wrong dates" do
      expect(FactoryGirl.build(:travel_expense_report_wrong_dates).valid?).to be false
    end
    it "rejects negative advances" do
      expect(FactoryGirl.build(:travel_expense_report_negative_advance).valid?).to be false
    end
  end
end
