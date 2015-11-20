require 'rails_helper'

RSpec.describe "project_applications/new", type: :view do
  before(:each) do
    assign(:project_application, ProjectApplication.new(
      :project_id => 1,
      :user_id => 1,
      :status => 1
    ))
  end

  it "renders new project_application form" do
    render

    assert_select "form[action=?][method=?]", project_applications_path, "post" do

      assert_select "input#project_application_project_id[name=?]", "project_application[project_id]"

      assert_select "input#project_application_user_id[name=?]", "project_application[user_id]"

      assert_select "input#project_application_status[name=?]", "project_application[status]"
    end
  end
end
