require 'rails_helper'

RSpec.describe 'travel_expense_reports/new', type: :view do
  before(:each) do
    assign(:travel_expense_report, TravelExpenseReport.new(
                                     inland: true,
                                     country: 'MyString',
                                     location_from: 'MyString',
                                     location_via: 'MyString',
                                     location_to: 'MyString',
                                     reason: 'MyText',
                                     car: false,
                                     public_transport: false,
                                     vehicle_advance: false,
                                     hotel: false,
                                     general_advance: 1,
                                     signature: false,
                                     user: FactoryGirl.create(:user)
    ))
  end

  it 'renders new travel_expense_report form' do
    render

    assert_select 'form[action=?][method=?]', travel_expense_reports_path, 'post' do
      assert_select 'input#travel_expense_report_location_from[name=?]', 'travel_expense_report[location_from]'

      assert_select 'input#travel_expense_report_location_via[name=?]', 'travel_expense_report[location_via]'

      assert_select 'input#travel_expense_report_location_to[name=?]', 'travel_expense_report[location_to]'

      assert_select 'textarea#travel_expense_report_reason[name=?]', 'travel_expense_report[reason]'

      assert_select 'input#travel_expense_report_car[name=?]', 'travel_expense_report[car]'

      assert_select 'input#travel_expense_report_public_transport[name=?]', 'travel_expense_report[public_transport]'

      assert_select 'input#travel_expense_report_vehicle_advance[name=?]', 'travel_expense_report[vehicle_advance]'

      assert_select 'input#travel_expense_report_hotel[name=?]', 'travel_expense_report[hotel]'

      assert_select 'input#travel_expense_report_general_advance[name=?]', 'travel_expense_report[general_advance]'
    end
  end
end
