require 'rails_helper'

RSpec.describe "travel_expense_reports/index", type: :view do
  before(:each) do
    assign(:travel_expense_reports, [
      TravelExpenseReport.create!(
        :trip => nil
      ),
      TravelExpenseReport.create!(
        :trip => nil
      )
    ])
  end

  it "renders a list of travel_expense_reports" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
