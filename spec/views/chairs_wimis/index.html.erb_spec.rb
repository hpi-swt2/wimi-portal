require 'rails_helper'

RSpec.describe "chairs_wimis/index", type: :view do
  before(:each) do
    assign(:chairs_wimis, [
      ChairsWimi.create!(
        :user => nil,
        :chair => nil
      ),
      ChairsWimi.create!(
        :user => nil,
        :chair => nil
      )
    ])
  end

  it "renders a list of chairs_wimis" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
