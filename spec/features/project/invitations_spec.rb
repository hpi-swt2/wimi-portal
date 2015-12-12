require 'rails_helper'

describe 'project inviations' do
  before :each do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, title: "Invitation Project")
    login_as @user
  end

  it 'shows an inviation after the user has been invited' do
    Invitation.create(user: @user, project: @project)
    visit '/dashboard'
    expect(page).to have_content('Du wurdest zum Project Invitation Project eingeladen.')
  end

  it 'adds the user to the project if he accepts' do
    expect(@project.users.size).to eq 0
    Invitation.create(user: @user, project: @project)
    visit '/dashboard'
    click_on 'Annehmen'
    expect(page).to have_content "Du bist nun Mitglied dieses Projekts!"
    @project.reload
    expect(@project.users.size).to eq 1
  end

  it 'does not add the user to the project if he declines' do
    expect(@project.users.size).to eq 0
    Invitation.create(user: @user, project: @project)
    visit '/dashboard'
    click_on 'Ablehnen'
    @project.reload
    expect(@project.users.size).to eq 0
  end
end