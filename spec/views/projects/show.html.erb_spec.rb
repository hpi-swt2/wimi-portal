require 'rails_helper'

RSpec.describe 'projects/show', type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    allow(view).to receive(:current_user).and_return(@user)
    @project = assign(:project, Project.create!(:title => 'My Project'))
  end

  it 'renders attributes in <p>' do
    render
  end
end
