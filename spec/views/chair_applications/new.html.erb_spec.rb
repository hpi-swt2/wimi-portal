require 'rails_helper'

RSpec.describe "chair_applications/new", type: :view do
  before(:each) do
    assign(:chair_application, ChairApplication.new(
      :user => nil,
      :chair => nil,
      :status => 1
    ))
  end

  it "renders new chair_application form" do
    render

    assert_select "form[action=?][method=?]", chair_applications_path, "post" do

      assert_select "input#chair_application_user_id[name=?]", "chair_application[user_id]"

      assert_select "input#chair_application_chair_id[name=?]", "chair_application[chair_id]"

      assert_select "input#chair_application_status[name=?]", "chair_application[status]"
    end
  end
end
