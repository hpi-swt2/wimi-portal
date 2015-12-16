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
    page.find('#currentUserCheckbox')
  end

  # it 'has the accessibility public after a project was newly created' do
  #   project2 = FactoryGirl.create(:project)
  #   visit "/projects/#{project2.id}/edit"
  #   expect(page).to have_selector 'input[type=radio][checked=checked][id=project_public_true]'
  # end
  #
  # it 'has the status active after a project was newly created' do
  #   project3 = FactoryGirl.create(:project)
  #   visit "/projects/#{project3.id}/edit"
  #   expect(page).to have_selector 'input[type=radio][checked=checked][id=project_status_true]'
  # end

end