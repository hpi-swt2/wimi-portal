require 'rails_helper'

RSpec.describe "work_months/index", type: :view do
  before(:each) do
    assign(:work_months, [
      WorkMonth.create!(
        :name => "Name",
        :year => 1
      ),
      WorkMonth.create!(
        :name => "Name",
        :year => 1
      )
    ])
  end

  it "renders a list of work_months" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
