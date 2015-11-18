require 'rails_helper'

RSpec.describe "work_months/show", type: :view do
  before(:each) do
    @work_month = assign(:work_month, WorkMonth.create!(
      :name => "Name",
      :year => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
  end
end
