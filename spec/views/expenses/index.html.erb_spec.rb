require 'rails_helper'

RSpec.describe 'expenses/index', type: :view do
  before(:each) do
    assign(:expenses, [
      Expense.create!(amount: 200,
        purpose: 'Clubmate',
        comment: 'ist ein koffeinhaltiges, alkoholfreies Erfrischungsgetränk der Brauerei Loscher aus Münchsteinach',
        user_id: 1,
        project_id: nil,
        trip_id: nil),
      Expense.create!(amount: 200,
        purpose: 'Clubmate',
        comment: 'ist ein koffeinhaltiges, alkoholfreies Erfrischungsgetränk der Brauerei Loscher aus Münchsteinach',
        user_id: 1,
        project_id: nil,
        trip_id: nil)
    ])
  end

  it 'renders a list of expenses' do
    render
  end
end
