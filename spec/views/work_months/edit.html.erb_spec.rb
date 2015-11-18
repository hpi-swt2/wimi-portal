require 'rails_helper'

RSpec.describe "work_months/edit", type: :view do
  before(:each) do
    @work_month = assign(:work_month, WorkMonth.create!(
      :name => "MyString",
      :year => 1
    ))
  end

  it "renders the edit work_month form" do
    render

    assert_select "form[action=?][method=?]", work_month_path(@work_month), "post" do

      assert_select "input#work_month_name[name=?]", "work_month[name]"

      assert_select "input#work_month_year[name=?]", "work_month[year]"
    end
  end
end
