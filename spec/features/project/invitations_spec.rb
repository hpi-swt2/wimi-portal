require 'rails_helper'

describe 'project inviations' do
  before :each do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, title: 'Invitation Project')
    login_as @user
  end

  it 'does not show the invitation button if the wimi does not belong to the project' do
    chair1 = FactoryGirl.create(:chair)
    chair2 = FactoryGirl.create(:chair)
    user1 = FactoryGirl.create(:user)
    representative1 = FactoryGirl.create(:chair_representative, user: user1, chair: chair2).user
    wimi1 = FactoryGirl.create(:wimi, user: @user, chair: chair1, application: 'accepted')
    @project.update(chair: representative1.chair)
    expect(@user.is_wimi?).to be true
    visit "/projects/#{@project.id}"
    expect(page).to_not have_link(I18n.t('project.invite_someone_to_project'))
  end

  it 'does show the invitation button if the wimi belongs to the project' do
    chair1 = FactoryGirl.create(:chair)
    user1 = FactoryGirl.create(:user)
    representative1 = FactoryGirl.create(:chair_representative, user: user1, chair: chair1).user
    wimi1 = FactoryGirl.create(:wimi, user: @user, chair: representative1.chair, application: 'accepted')
    @project.update(chair: wimi1.chair)
    expect(@user.is_wimi?).to be true
    @user.projects << @project
    visit "/projects/#{@project.id}"
    expect(page).to have_link(I18n.t('project.invite_someone_to_project'))
  end

  it 'shows a notification after the user has been invited' do
    invitation = FactoryGirl.create(:invitation, user: @user, project: @project, sender: @user)
    FactoryGirl.create(:event_project_invitation, trigger: invitation, target: @user, seclevel: :hiwi, type: "EventProjectInvitation")
    visit '/dashboard'
    content = @user.name + ' invites you to join the project ' + invitation.project.title
    expect(page).to have_content(content)
  end

  it 'adds the user to the project if he accepts' do
    expect(@project.users.size).to eq 0
    chair1 = FactoryGirl.create(:chair)
    user1 = FactoryGirl.create(:user)
    representative1 = FactoryGirl.create(:chair_representative, user: user1, chair: chair1).user
    @project.update(chair: representative1.chair)
    invitation = FactoryGirl.create(:invitation, user: @user, project: @project, sender: user1)
    FactoryGirl.create(:event_project_invitation, trigger: invitation, target: @user, seclevel: :hiwi, type: "EventProjectInvitation")
    visit '/dashboard'
    click_on 'Accept'
    expect(page).to have_content 'You are now a member of this project.'
    @project.reload
    expect(@project.users.size).to eq 1
  end

  it 'does not add the user to the project if he declines' do
    expect(@project.users.size).to eq 0
    invitation = FactoryGirl.create(:invitation, user: @user, project: @project, sender: @user)
    FactoryGirl.create(:event_project_invitation, trigger: invitation, target: @user, seclevel: :hiwi, type: "EventProjectInvitation")
    visit '/dashboard'
    click_on 'Decline'
    @project.reload
    expect(@project.users.size).to eq 0
  end

  it 'assigns the user as a wimi if he already is a wimi' do
    chair1 = FactoryGirl.create(:chair)
    wimi1 = FactoryGirl.create(:wimi, user: @user, chair: chair1, application: 'accepted')

    chair2 = FactoryGirl.create(:chair)
    chair2.projects << @project
    expect(@user.is_wimi?).to be true
    invitation = FactoryGirl.create(:invitation, user: @user, project: @project, sender: @user)
    FactoryGirl.create(:event_project_invitation, trigger: invitation, target: @user, seclevel: :hiwi, type: "EventProjectInvitation")

    visit '/dashboard'
    click_on 'Decline'
    expect(@user.is_wimi?).to be true
  end

  it 'assigns the user as a hiwi if he has no role yet' do
    chair = FactoryGirl.create(:chair, name: 'Test Chair')
    user1 = FactoryGirl.create(:user)
    representative1 = FactoryGirl.create(:chair_representative, user: user1, chair: chair).user
    @project.update(chair: representative1.chair)
    chair.projects << @project
    expect(chair.hiwis.size).to eq 0

    invitation = FactoryGirl.create(:invitation, user: @user, project: @project, sender: @user)
    FactoryGirl.create(:event_project_invitation, trigger: invitation, target: @user, seclevel: :hiwi, type: "EventProjectInvitation")
    visit '/dashboard'
    click_on 'Accept'

    @project.reload
    expect(@project.hiwis.size).to eq 1
    expect(chair.hiwis.include?(@user)).to be true
  end
end
