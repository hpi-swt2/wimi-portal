require 'rails_helper'

RSpec.describe 'projects/show', type: :view do
  before(:each) do
    sign_in FactoryGirl.create(:user)
    @project = assign(:project, Project.create!(:title => 'My Project'))
  end

  it 'renders attributes in <p>' do
    render
  end
end
