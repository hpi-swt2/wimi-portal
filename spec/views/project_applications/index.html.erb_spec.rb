require 'spec_helper'
require 'rails_helper'

RSpec.describe 'project_applications/index', type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project)

    sign_in @user
    assign(:project_applications, [
      FactoryGirl.create(:project_application, user_id: @user.id, project_id: @project.id)
    ])
  end

  it 'renders a list of project_applications' do
    render
  end
end
