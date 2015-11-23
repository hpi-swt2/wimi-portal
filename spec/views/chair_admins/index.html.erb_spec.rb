require 'rails_helper'

RSpec.describe "chair_admins/index", type: :view do
  before(:each) do
    assign(:chair_admins, [
      ChairAdmin.create!(
        :user => nil,
        :chair => nil
      ),
      ChairAdmin.create!(
        :user => nil,
        :chair => nil
      )
    ])
  end

  it "renders a list of chair_admins" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
