require 'rails_helper'

RSpec.describe "time_sheets/show", type: :view do
  before(:each) do
    @time_sheet = assign(:time_sheet, TimeSheet.create!(
      :month => 1,
      :yeat => 2,
      :salary => 3,
      :salary_is_per_month => false,
      :workload => 4,
      :workload_is_per_month => false,
      :user_id => 5,
      :project_id => 6
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
  end
end
