require 'rails_helper'

RSpec.describe "chair_wimis/show", type: :view do
  before(:each) do
    @chair_wimi = assign(:chair_wimi, ChairWimi.create!(
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
