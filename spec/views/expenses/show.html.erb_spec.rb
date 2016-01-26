require 'rails_helper'

RSpec.describe 'expenses/show', type: :view do
  before(:each) do
    @expense = assign(:expense, FactoryGirl.create(:expense))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Germany/)
    expect(rendered).to match(/NYC/)
    expect(rendered).to match(/2000/)
    expect(rendered).to match(/Potsdam/)
  end
end
