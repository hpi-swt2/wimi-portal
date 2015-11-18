require 'rails_helper'

RSpec.describe "work_months/new", type: :view do
  before(:each) do
    assign(:work_month, WorkMonth.new(
      :name => "MyString",
      :year => 1
    ))
  end

  it "renders new work_month form" do
    render

    assert_select "form[action=?][method=?]", work_months_path, "post" do

      assert_select "input#work_month_name[name=?]", "work_month[name]"

      assert_select "input#work_month_year[name=?]", "work_month[year]"
    end
  end
end
