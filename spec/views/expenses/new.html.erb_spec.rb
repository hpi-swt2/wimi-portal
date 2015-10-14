require 'rails_helper'

RSpec.describe 'expenses/new', type: :view do
  before(:each) do
    assign(:expense, Expense.new(amount: 200,
      purpose: 'Clubmate',
      comment: 'ist ein koffeinhaltiges, alkoholfreies Erfrischungsgetränk der Brauerei Loscher aus Münchsteinach',
      user_id: 1,
      project_id: nil,
      trip_id: nil))
  end

  it 'renders new expense form' do
    render

    assert_select 'form[action=?][method=?]', expenses_path, 'post' do
    end
  end
end
