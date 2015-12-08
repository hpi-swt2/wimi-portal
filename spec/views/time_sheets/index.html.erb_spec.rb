require 'rails_helper'

RSpec.describe "time_sheets/index", type: :view do
  before(:each) do
    assign(:time_sheets, [
      TimeSheet.create!(
        :month => 1,
        :yeat => 2,
        :salary => 3,
        :salary_is_per_month => false,
        :workload => 4,
        :workload_is_per_month => false,
        :user_id => 5,
        :project_id => 6
      ),
      TimeSheet.create!(
        :month => 1,
        :yeat => 2,
        :salary => 3,
        :salary_is_per_month => false,
        :workload => 4,
        :workload_is_per_month => false,
        :user_id => 5,
        :project_id => 6
      )
    ])
  end

  it "renders a list of time_sheets" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
  end
end
