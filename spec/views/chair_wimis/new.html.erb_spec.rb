require 'rails_helper'

RSpec.describe "chair_wimis/new", type: :view do
  before(:each) do
    assign(:chair_wimi, ChairWimi.new(
      :user => nil,
      :chair => nil
    ))
  end

  it "renders new chair_wimi form" do
    render

    assert_select "form[action=?][method=?]", chair_wimis_path, "post" do

      assert_select "input#chair_wimi_user_id[name=?]", "chair_wimi[user_id]"

      assert_select "input#chair_wimi_chair_id[name=?]", "chair_wimi[chair_id]"
    end
  end
end
