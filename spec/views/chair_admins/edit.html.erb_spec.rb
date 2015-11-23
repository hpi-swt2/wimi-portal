require 'rails_helper'

RSpec.describe "chair_admins/edit", type: :view do
  before(:each) do
    @chair_admin = assign(:chair_admin, ChairAdmin.create!(
      :user => nil,
      :chair => nil
    ))
  end

  it "renders the edit chair_admin form" do
    render

    assert_select "form[action=?][method=?]", chair_admin_path(@chair_admin), "post" do

      assert_select "input#chair_admin_user_id[name=?]", "chair_admin[user_id]"

      assert_select "input#chair_admin_chair_id[name=?]", "chair_admin[chair_id]"
    end
  end
end
