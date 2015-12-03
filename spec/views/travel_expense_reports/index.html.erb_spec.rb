require 'rails_helper'

RSpec.describe "travel_expense_reports/index", type: :view do
  before(:each) do
    assign(:travel_expense_reports, [
      TravelExpenseReport.create!(
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
      ),
      TravelExpenseReport.create!(
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
      )
    ])
  end

  it "renders a list of travel_expense_reports" do
    render
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => "Location From".to_s, :count => 2
    assert_select "tr>td", :text => "Location Via".to_s, :count => 2
    assert_select "tr>td", :text => "Location To".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
