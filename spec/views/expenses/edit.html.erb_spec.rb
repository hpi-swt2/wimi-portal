require 'rails_helper'

RSpec.describe 'expenses/edit', type: :view do
  before(:each) do
    @expense = assign(:expense, FactoryGirl.create(:expense))
  end

  it 'renders the edit expense form' do
    render

    assert_select 'form[action=?][method=?]', trip_expense_path(@expense,@expense.trip), 'post' do
      assert_select 'input#expense_location_from[name=?]', 'expense[location_from]'

      assert_select 'input#expense_location_via[name=?]', 'expense[location_via]'

      assert_select 'textarea#expense_reason[name=?]', 'expense[reason]'

      assert_select 'input#expense_car[name=?]', 'expense[car]'

      assert_select 'input#expense_public_transport[name=?]', 'expense[public_transport]'

      assert_select 'input#expense_vehicle_advance[name=?]', 'expense[vehicle_advance]'

      assert_select 'input#expense_hotel[name=?]', 'expense[hotel]'

      assert_select 'input#expense_general_advance[name=?]', 'expense[general_advance]'
    end
  end
end
