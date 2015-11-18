require 'rails_helper'

RSpec.describe "chairs_wimis/show", type: :view do
  before(:each) do
    @chairs_wimi = assign(:chairs_wimi, ChairsWimi.create!(
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
