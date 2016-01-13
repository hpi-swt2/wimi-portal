require 'rails_helper'

RSpec.describe 'projects/index', type: :view do
  before(:each) do
    sign_in FactoryGirl.create(:user)
    assign(:projects, [
      FactoryGirl.create(:project),
      FactoryGirl.create(:project)
    ])
    @user = FactoryGirl.create(:user)
    login_as @user
  end

  it 'renders a list of projects' do
    render
  end
end
