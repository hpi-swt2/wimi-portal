require 'rails_helper'

RSpec.describe "project_applications/index", type: :view do
  before(:each) do
    assign(:project_applications, [
      ProjectApplication.create!(
        :project_id => 1,
        :user_id => 2,
        :status => 3
      ),
      ProjectApplication.create!(
        :project_id => 1,
        :user_id => 2,
        :status => 3
      )
    ])
  end

  it "renders a list of project_applications" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
