require 'rails_helper'

RSpec.describe "chairs_administrators/new", type: :view do
  before(:each) do
    assign(:chairs_administrator, ChairsAdministrator.new(
      :user => nil,
      :chair => nil
    ))
  end

  it "renders new chairs_administrator form" do
    render

    assert_select "form[action=?][method=?]", chairs_administrators_path, "post" do

      assert_select "input#chairs_administrator_user_id[name=?]", "chairs_administrator[user_id]"

      assert_select "input#chairs_administrator_chair_id[name=?]", "chairs_administrator[chair_id]"
    end
  end
end
