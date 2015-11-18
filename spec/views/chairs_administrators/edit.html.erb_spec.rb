require 'rails_helper'

RSpec.describe "chairs_administrators/edit", type: :view do
  before(:each) do
    @chairs_administrator = assign(:chairs_administrator, ChairsAdministrator.create!(
      :user => nil,
      :chair => nil
    ))
  end

  it "renders the edit chairs_administrator form" do
    render

    assert_select "form[action=?][method=?]", chairs_administrator_path(@chairs_administrator), "post" do

      assert_select "input#chairs_administrator_user_id[name=?]", "chairs_administrator[user_id]"

      assert_select "input#chairs_administrator_chair_id[name=?]", "chairs_administrator[chair_id]"
    end
  end
end
