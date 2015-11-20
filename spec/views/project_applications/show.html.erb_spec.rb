require 'rails_helper'

RSpec.describe "project_applications/show", type: :view do
  before(:each) do
    @project_application = assign(:project_application, ProjectApplication.create!(
      :project_id => 1,
      :user_id => 2,
      :status => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
