require 'rails_helper'

RSpec.describe "chair_applications/edit", type: :view do
  before(:each) do
    @chair_application = assign(:chair_application, ChairApplication.create!(
      :user => nil,
      :chair => nil,
      :status => 1
    ))
  end

  it "renders the edit chair_application form" do
    render

    assert_select "form[action=?][method=?]", chair_application_path(@chair_application), "post" do

      assert_select "input#chair_application_user_id[name=?]", "chair_application[user_id]"

      assert_select "input#chair_application_chair_id[name=?]", "chair_application[chair_id]"

      assert_select "input#chair_application_status[name=?]", "chair_application[status]"
    end
  end
end
