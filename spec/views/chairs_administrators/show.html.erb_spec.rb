require 'rails_helper'

RSpec.describe "chairs_administrators/show", type: :view do
  before(:each) do
    @chairs_administrator = assign(:chairs_administrator, ChairsAdministrator.create!(
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
