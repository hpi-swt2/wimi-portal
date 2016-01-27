require 'rails_helper'

describe 'create project with invitations' do
  before :each do
    @wimi = FactoryGirl.create(:wimi, chair: FactoryGirl.create(:chair), user: FactoryGirl.create(:user)).user
    login_as @wimi
    visit new_project_path
    fill_in 'project_title', with: 'Test Project'
  end


  it 'does not invite the creator of the project' do
    fill_in 'invitation_mail', with: @wimi.email
    click_on 'Add new User'
    click_on 'Create Project'
    expect(Project.last.invitations.count).to eq(0)
  end

  it 'does not invite people that do not exist'  do
    fill_in 'invitation_mail', with: 'not even a mail address'
    click_on 'Add new User'
    click_on 'Create Project'
    expect(Project.last.invitations.count).to eq(0)
  end
   
end
