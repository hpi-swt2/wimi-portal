require 'rails_helper'

RSpec.describe "chair_representatives/index", type: :view do
  before(:each) do
    assign(:chair_representatives, [
      ChairRepresentative.create!(
        :user => nil,
        :chair => nil
      ),
      ChairRepresentative.create!(
        :user => nil,
        :chair => nil
      )
    ])
  end

  it "renders a list of chair_representatives" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
