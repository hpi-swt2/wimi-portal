require 'rails_helper'

RSpec.describe "chairs_administrators/index", type: :view do
  before(:each) do
    assign(:chairs_administrators, [
      ChairsAdministrator.create!(
        :user => nil,
        :chair => nil
      ),
      ChairsAdministrator.create!(
        :user => nil,
        :chair => nil
      )
    ])
  end

  it "renders a list of chairs_administrators" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
