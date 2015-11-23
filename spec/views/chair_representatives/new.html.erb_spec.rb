require 'rails_helper'

RSpec.describe "chair_representatives/new", type: :view do
  before(:each) do
    assign(:chair_representative, ChairRepresentative.new(
      :user => nil,
      :chair => nil
    ))
  end

  it "renders new chair_representative form" do
    render

    assert_select "form[action=?][method=?]", chair_representatives_path, "post" do

      assert_select "input#chair_representative_user_id[name=?]", "chair_representative[user_id]"

      assert_select "input#chair_representative_chair_id[name=?]", "chair_representative[chair_id]"
    end
  end
end
