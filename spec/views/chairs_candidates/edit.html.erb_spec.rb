require 'rails_helper'

RSpec.describe "chairs_candidates/edit", type: :view do
  before(:each) do
    @chairs_candidate = assign(:chairs_candidate, ChairsCandidate.create!(
      :user => nil,
      :chair => nil
    ))
  end

  it "renders the edit chairs_candidate form" do
    render

    assert_select "form[action=?][method=?]", chairs_candidate_path(@chairs_candidate), "post" do

      assert_select "input#chairs_candidate_user_id[name=?]", "chairs_candidate[user_id]"

      assert_select "input#chairs_candidate_chair_id[name=?]", "chairs_candidate[chair_id]"
    end
  end
end
