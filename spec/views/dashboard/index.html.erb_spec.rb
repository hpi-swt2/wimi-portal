require 'rails_helper'

RSpec.describe 'dashboard/index.html.erb', type: :view do
  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  it 'displays the projects of the user' do
    project1 = FactoryGirl.create(:project)
    project2 = FactoryGirl.create(:project, title: 'Unassigned Project')
    project1.users << @user
    render
    expect(rendered).to have_content('My Projects')
    expect(rendered).to have_content(project1.title)
    expect(rendered).to_not have_content(project2.title)
  end

  it 'shows content for users without any chair or project' do
    login_as(@user, :scope => :user)
    chair1 = FactoryGirl.create(:chair, name: 'Chair1')
    chair2 = FactoryGirl.create(:chair, name: 'Chair2')
    visit dashboard_path

    expect(page).to have_content(chair1.name)
    expect(page).to have_content(chair2.name)
    expect(page).to have_content(I18n.t('activerecord.attributes.chair.apply'))
  end

  it 'performs an application after click on Apply' do
    login_as(@user, :scope => :user)
    chair1 = FactoryGirl.create(:chair, name: 'Chair1')
    visit dashboard_path

    expect(page).to have_content(chair1.name)
    expect(page).to have_content(I18n.t('activerecord.attributes.chair.apply'))
    expect(page).to_not have_content(I18n.t('activerecord.attributes.chair.application.status.pending'))
    click_on I18n.t('activerecord.attributes.chair.apply')
    expect(page).to have_content(I18n.t('activerecord.attributes.chair.application.status.pending'))
    expect(page).to_not have_content(I18n.t('activerecord.attributes.chair.apply'))
  end

  it 'shows invitations for projects' do
  #   TODO
  end

  it 'hides the content for chairless and projectless users for all other users' do
    chair1 = FactoryGirl.create(:chair, name: 'Chair1')
    chair2 = FactoryGirl.create(:chair, name: 'Chair2')
    chairwimi = ChairWimi.create(user_id: @user.id, chair_id: chair1.id, application: 'accepted')
    login_as(@user, :scope => :user)
    visit dashboard_path

    expect(page).to_not have_content(chair1.name)
    expect(page).to_not have_content(chair2.name)
    expect(page).to_not have_content(I18n.t('activerecord.attributes.chair.apply'))
  end
end
