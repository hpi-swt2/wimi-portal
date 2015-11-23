require 'rails_helper'

RSpec.describe "chair_representatives/show", type: :view do
  before(:each) do
    @chair_representative = assign(:chair_representative, ChairRepresentative.create!(
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
