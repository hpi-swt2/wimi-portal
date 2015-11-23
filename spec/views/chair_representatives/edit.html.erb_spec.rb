require 'rails_helper'

RSpec.describe "chair_representatives/edit", type: :view do
  before(:each) do
    @chair_representative = assign(:chair_representative, ChairRepresentative.create!(
      :user => nil,
      :chair => nil
    ))
  end

  it "renders the edit chair_representative form" do
    render

    assert_select "form[action=?][method=?]", chair_representative_path(@chair_representative), "post" do

      assert_select "input#chair_representative_user_id[name=?]", "chair_representative[user_id]"

      assert_select "input#chair_representative_chair_id[name=?]", "chair_representative[chair_id]"
    end
  end
end
