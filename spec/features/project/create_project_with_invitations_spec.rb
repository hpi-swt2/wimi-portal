require 'rails_helper'

describe 'create project with invitations' do
  before :each do
    @wimi = FactoryGirl.create(:wimi, chair: FactoryGirl.create(:chair), user: FactoryGirl.create(:user)).user
    login_as @wimi
    visit new_project_path
    fill_in 'project_title', with: 'Test Project'
  end

  # it 'invites people to the project' do
  #   fill_in 'invitation_mail', with: FactoryGirl.create(:user).email
  #   click_link_or_button 'Add new User'
  #   expect(page).to have_content(User.last.email)
  #   expect(page).to have_link_or_button('Remove Invitation')
  #   click_on 'Create Project'
  #   expect(User.last.invitations.count).to eq(1)
  # end

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

  # it 'does not invite people that were invited at first but then deleted'  do
  #   fill_in 'invitation_mail', with: FactoryGirl.create(:user).email
  #   click_on 'Add new User'
  #   # expect(page).to have_content(User.last.email)
  #   # expect(page).to have_button('Remove Invitation')
  #   click_on 'Remove Invitation'
  #   click_on 'Create Project'
  #   expect(Project.last.invitations.count).to eq(0)
  # end
end
