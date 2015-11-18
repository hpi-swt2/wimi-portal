require 'rails_helper'

RSpec.describe "chairs_candidates/show", type: :view do
  before(:each) do
    @chairs_candidate = assign(:chairs_candidate, ChairsCandidate.create!(
      :user => nil,
      :chair => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
