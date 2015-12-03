require 'rails_helper'

RSpec.describe 'expenses/edit', type: :view do
  before(:each) do
    @expense = assign(:expense, Expense.create!(amount: 200,
      purpose: 'Clubmate',
      comment: 'ist ein koffeinhaltiges, alkoholfreies Erfrischungsgetränk der Brauerei Loscher aus Münchsteinach',
      user_id: 1,
      project_id: nil,
      trip_id: nil))
  end


  it 'renders the edit expense form' do
    render
 
    assert_select 'form[action=?][method=?]', expense_path(@expense), 'post' do
    end
  end
end
