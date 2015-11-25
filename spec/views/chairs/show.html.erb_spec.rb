require 'rails_helper'

RSpec.describe "chairs/show", type: :view do
  before(:each) do
    @chair = assign(:chair, Chair.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
