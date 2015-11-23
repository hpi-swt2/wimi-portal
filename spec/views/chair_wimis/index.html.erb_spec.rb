require 'rails_helper'

RSpec.describe "chair_wimis/index", type: :view do
  before(:each) do
    assign(:chair_wimis, [
      ChairWimi.create!(
        :user => nil,
        :chair => nil
      ),
      ChairWimi.create!(
        :user => nil,
        :chair => nil
      )
    ])
  end

  it "renders a list of chair_wimis" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
