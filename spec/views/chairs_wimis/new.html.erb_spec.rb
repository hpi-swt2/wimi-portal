require 'rails_helper'

RSpec.describe "chairs_wimis/new", type: :view do
  before(:each) do
    assign(:chairs_wimi, ChairsWimi.new(
      :user => nil,
      :chair => nil
    ))
  end

  it "renders new chairs_wimi form" do
    render

    assert_select "form[action=?][method=?]", chairs_wimis_path, "post" do

      assert_select "input#chairs_wimi_user_id[name=?]", "chairs_wimi[user_id]"

      assert_select "input#chairs_wimi_chair_id[name=?]", "chairs_wimi[chair_id]"
    end
  end
end
