require 'rails_helper'

RSpec.describe 'expenses/show', type: :view do
  before(:each) do
    @expense = assign(:expense, Expense.create!(amount: 200,
      purpose: 'Clubmate',
      comment: 'ist ein koffeinhaltiges, alkoholfreies Erfrischungsgetränk der Brauerei Loscher aus Münchsteinach',
      user_id: 1,
      project_id: nil,
      trip_id: nil))
  end

  it 'renders attributes in <p>' do
    render
  end
end
