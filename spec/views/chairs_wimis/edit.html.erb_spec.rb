require 'rails_helper'

RSpec.describe "chairs_wimis/edit", type: :view do
  before(:each) do
    @chairs_wimi = assign(:chairs_wimi, ChairsWimi.create!(
      :user => nil,
      :chair => nil
    ))
  end

  it "renders the edit chairs_wimi form" do
    render

    assert_select "form[action=?][method=?]", chairs_wimi_path(@chairs_wimi), "post" do

      assert_select "input#chairs_wimi_user_id[name=?]", "chairs_wimi[user_id]"

      assert_select "input#chairs_wimi_chair_id[name=?]", "chairs_wimi[chair_id]"
    end
  end
end
