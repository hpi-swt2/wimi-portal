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
      expect{FactoryGirl.create(:travel_expense_report_blank_name)}.to raise_error
    end
    it "rejects wrong dates" do
      expect{FactoryGirl.create(:travel_expense_report_wrong_dates)}.to raise_error
    end
    it "rejects negative advances" do
      expect{FactoryGirl.create(:travel_expense_report_negative_advance)}.to raise_error
    end
  end
end
