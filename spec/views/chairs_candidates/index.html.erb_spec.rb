require 'rails_helper'

RSpec.describe "chairs_candidates/index", type: :view do
  before(:each) do
    assign(:chairs_candidates, [
      ChairsCandidate.create!(
        :user => nil,
        :chair => nil
      ),
      ChairsCandidate.create!(
        :user => nil,
        :chair => nil
      )
    ])
  end

  it "renders a list of chairs_candidates" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
