require 'rails_helper'

RSpec.describe "chairs/index", type: :view do
  before(:each) do
    assign(:chairs, [
      Chair.create!(
        :name => "Name"
      ),
      Chair.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of chairs" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
