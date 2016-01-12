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
    representative1 = FactoryGirl.create(:chair_representative, user_id:user1.id, chair_id: chair2.id).user
    wimi1 = FactoryGirl.create(:chair_wimi, user: @user, chair: chair1, application: 'accepted')
    @project.update(chair: representative1.chair)
    expect(@user.is_wimi?).to be true
    visit "/projects/#{@project.id}"
    expect(page).to_not have_link(I18n.t('project.invite_someone_to_project'))
  end

  it 'does show the invitation button if the wimi belongs to the project' do
    chair1 = FactoryGirl.create(:chair)
    user1 = FactoryGirl.create(:user)
    representative1 = FactoryGirl.create(:chair_representative, user_id:user1.id, chair_id: chair1.id).user
    wimi1 = FactoryGirl.create(:chair_wimi, user: @user, chair: representative1.chair, application: 'accepted')
    @project.update(chair: wimi1.chair)
    expect(@user.is_wimi?).to be true
    @user.projects << @project
    visit "/projects/#{@project.id}"
    expect(page).to have_link(I18n.t('project.invite_someone_to_project'))
  end

  it 'shows an inviation after the user has been invited' do
    FactoryGirl.create(:invitation, user: @user, project: @project)
    visit '/dashboard'
    expect(page).to have_content('You have been invited to the project "Invitation Project"')
  end

  it 'adds the user to the project if he accepts' do
    expect(@project.users.size).to eq 0
    chair1 = FactoryGirl.create(:chair)
    user1 = FactoryGirl.create(:user)
    representative1 = FactoryGirl.create(:chair_representative, user_id:user1.id, chair_id: chair1.id).user
    @project.update(chair: representative1.chair)
    FactoryGirl.create(:invitation, user: @user, project: @project)
    visit '/dashboard'
    click_on 'Accept'
    expect(page).to have_content 'You are now a member of this project.'
    @project.reload
    expect(@project.users.size).to eq 1
  end

  it 'does not add the user to the project if he declines' do
    expect(@project.users.size).to eq 0
    FactoryGirl.create(:invitation, user: @user, project: @project)
    visit '/dashboard'
    click_on 'Decline'
    @project.reload
    expect(@project.users.size).to eq 0
  end

  it 'assigns the user as a wimi if he already is a wimi' do
    chair1 = FactoryGirl.create(:chair)
    wimi1 = FactoryGirl.create(:chair_wimi, user: @user, chair: chair1, application: 'accepted')

    chair2 = FactoryGirl.create(:chair)
    chair2.projects << @project
    expect(@user.is_wimi?).to be true
    invitation = FactoryGirl.create(:invitation, user: @user, project: @project)

    visit '/dashboard'
    click_on 'Decline'
    expect(@user.is_wimi?).to be true
  end

  it 'assigns the user as a hiwi if he has no role yet' do
    chair = FactoryGirl.create(:chair, name: 'Test Chair')
    user1 = FactoryGirl.create(:user)
    representative1 = FactoryGirl.create(:chair_representative, user_id:user1.id, chair_id: chair.id).user
    @project.update(chair: representative1.chair)
    chair.projects << @project
    expect(chair.hiwis.size).to eq 0

    invitation = FactoryGirl.create(:invitation, user: @user, project: @project)
    visit '/dashboard'
    click_on 'Accept'

    @project.reload
    expect(@project.hiwis.size).to eq 1
    expect(chair.hiwis.include?(@user)).to be true
  end
end