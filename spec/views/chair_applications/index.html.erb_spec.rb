require 'rails_helper'

RSpec.describe "chair_applications/index", type: :view do
  before(:each) do
    assign(:chair_applications, [
      ChairApplication.create!(
        :user => nil,
        :chair => nil,
        :status => 1
      ),
      ChairApplication.create!(
        :user => nil,
        :chair => nil,
        :status => 1
      )
    ])
  end

  it "renders a list of chair_applications" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
