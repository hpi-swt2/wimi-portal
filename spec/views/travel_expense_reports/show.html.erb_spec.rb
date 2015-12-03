require 'rails_helper'

RSpec.describe "travel_expense_reports/show", type: :view do
  before(:each) do
    @travel_expense_report = assign(:travel_expense_report, TravelExpenseReport.create!(
      :first_name => "First Name",
      :last_name => "Last Name",
      :inland => false,
      :country => "Country",
      :location_from => "Location From",
      :location_via => "Location Via",
      :location_to => "Location To",
      :reason => "MyText",
      :car => false,
      :public_transport => false,
      :vehicle_advance => false,
      :hotel => false,
      :general_advance => 1,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/Location From/)
    expect(rendered).to match(/Location Via/)
    expect(rendered).to match(/Location To/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(//)
  end
end
