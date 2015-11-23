require 'rails_helper'

RSpec.describe "chair_wimis/edit", type: :view do
  before(:each) do
    @chair_wimi = assign(:chair_wimi, ChairWimi.create!(
      :user => nil,
      :chair => nil
    ))
  end

  it "renders the edit chair_wimi form" do
    render

    assert_select "form[action=?][method=?]", chair_wimi_path(@chair_wimi), "post" do

      assert_select "input#chair_wimi_user_id[name=?]", "chair_wimi[user_id]"

      assert_select "input#chair_wimi_chair_id[name=?]", "chair_wimi[chair_id]"
    end
  end
end
