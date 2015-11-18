require 'rails_helper'

RSpec.describe "chairs_candidates/new", type: :view do
  before(:each) do
    assign(:chairs_candidate, ChairsCandidate.new(
      :user => nil,
      :chair => nil
    ))
  end

  it "renders new chairs_candidate form" do
    render

    assert_select "form[action=?][method=?]", chairs_candidates_path, "post" do

      assert_select "input#chairs_candidate_user_id[name=?]", "chairs_candidate[user_id]"

      assert_select "input#chairs_candidate_chair_id[name=?]", "chairs_candidate[chair_id]"
    end
  end
end
