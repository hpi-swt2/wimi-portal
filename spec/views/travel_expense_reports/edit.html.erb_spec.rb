require 'rails_helper'

RSpec.describe "travel_expense_reports/edit", type: :view do
  before(:each) do
    @travel_expense_report = assign(:travel_expense_report, TravelExpenseReport.create!(
      :first_name => "MyString",
      :last_name => "MyString",
      :inland => false,
      :country => "MyString",
      :location_from => "MyString",
      :location_via => "MyString",
      :location_to => "MyString",
      :reason => "MyText",
      :car => false,
      :public_transport => false,
      :vehicle_advance => false,
      :hotel => false,
      :general_advance => 1,
      :user => nil
    ))
  end

  it "renders the edit travel_expense_report form" do
    render

    assert_select "form[action=?][method=?]", travel_expense_report_path(@travel_expense_report), "post" do

      assert_select "input#travel_expense_report_first_name[name=?]", "travel_expense_report[first_name]"

      assert_select "input#travel_expense_report_last_name[name=?]", "travel_expense_report[last_name]"

      assert_select "input#travel_expense_report_inland[name=?]", "travel_expense_report[inland]"

      assert_select "input#travel_expense_report_country[name=?]", "travel_expense_report[country]"

      assert_select "input#travel_expense_report_location_from[name=?]", "travel_expense_report[location_from]"

      assert_select "input#travel_expense_report_location_via[name=?]", "travel_expense_report[location_via]"

      assert_select "input#travel_expense_report_location_to[name=?]", "travel_expense_report[location_to]"

      assert_select "textarea#travel_expense_report_reason[name=?]", "travel_expense_report[reason]"

      assert_select "input#travel_expense_report_car[name=?]", "travel_expense_report[car]"

      assert_select "input#travel_expense_report_public_transport[name=?]", "travel_expense_report[public_transport]"

      assert_select "input#travel_expense_report_vehicle_advance[name=?]", "travel_expense_report[vehicle_advance]"

      assert_select "input#travel_expense_report_hotel[name=?]", "travel_expense_report[hotel]"

      assert_select "input#travel_expense_report_general_advance[name=?]", "travel_expense_report[general_advance]"

      assert_select "input#travel_expense_report_user_id[name=?]", "travel_expense_report[user_id]"
    end
  end
end
