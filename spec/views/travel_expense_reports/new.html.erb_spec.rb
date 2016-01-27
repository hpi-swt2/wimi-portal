require 'rails_helper'

RSpec.describe 'expenses/new', type: :view do
  before(:each) do
    assign(:expense, Expense.new(
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

  it 'renders new expense form' do
    render

    assert_select 'form[action=?][method=?]', expenses_path, 'post' do
      assert_select 'input#expense_location_from[name=?]', 'expense[location_from]'

      assert_select 'input#expense_location_via[name=?]', 'expense[location_via]'

      assert_select 'input#expense_location_to[name=?]', 'expense[location_to]'

      assert_select 'textarea#expense_reason[name=?]', 'expense[reason]'

      assert_select 'input#expense_car[name=?]', 'expense[car]'

      assert_select 'input#expense_public_transport[name=?]', 'expense[public_transport]'

      assert_select 'input#expense_vehicle_advance[name=?]', 'expense[vehicle_advance]'

      assert_select 'input#expense_hotel[name=?]', 'expense[hotel]'

      assert_select 'input#expense_general_advance[name=?]', 'expense[general_advance]'
    end
  end
end
