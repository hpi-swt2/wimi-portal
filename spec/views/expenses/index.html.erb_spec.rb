require 'rails_helper'

RSpec.describe "expenses/index", type: :view do
  before(:each) do
    assign(:expenses, [
      Expense.create!(),
      Expense.create!()
    ])
  end

  it "renders a list of expenses" do
    render
  end
end
