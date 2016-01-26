require 'rails_helper'

RSpec.describe 'expenses/index', type: :view do
  before(:each) do
    assign(:expenses, [
      FactoryGirl.create(:expense),
      FactoryGirl.create(:expense_changed)
    ])
  end

  it 'renders a list of expenses' do
    render
    expect(rendered).to match /Hana Things/
    expect(rendered).to match /Berlin/
    expect(rendered).to match /Potsdam/
  end
end
