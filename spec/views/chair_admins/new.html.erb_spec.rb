require 'rails_helper'

RSpec.describe "chair_admins/new", type: :view do
  before(:each) do
    assign(:chair_admin, ChairAdmin.new(
      :user => nil,
      :chair => nil
    ))
  end

  it "renders new chair_admin form" do
    render

    assert_select "form[action=?][method=?]", chair_admins_path, "post" do

      assert_select "input#chair_admin_user_id[name=?]", "chair_admin[user_id]"

      assert_select "input#chair_admin_chair_id[name=?]", "chair_admin[chair_id]"
    end
  end
end
