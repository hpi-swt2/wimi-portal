require 'rails_helper'

RSpec.describe 'projects/index', type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_as @user
  end

  it 'changes checkbox id after user was assigned to a project' do
    project1 = FactoryGirl.create(:project)
    visit "/projects/#{project1.id}/edit"
    check "project_user_ids_#{@user.id}"
    click_button('Update Project')
    visit "/projects/#{project1.id}/edit"
    print page.html
    page.find('#currentUserCheckbox')
  end


end

