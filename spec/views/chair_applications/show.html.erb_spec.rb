require 'rails_helper'

RSpec.describe "chair_applications/show", type: :view do
  before(:each) do
    @chair_application = assign(:chair_application, ChairApplication.create!(
      :user => nil,
      :chair => nil,
      :status => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
  end
end
