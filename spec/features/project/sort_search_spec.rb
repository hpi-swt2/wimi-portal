require 'rails_helper'

describe 'project filtering and searching' do
  before :each do
    @user = FactoryBot.create(:user)
    @chair1 = FactoryBot.create(:chair, name: 'Chair1')
    @chair2 = FactoryBot.create(:chair, name: 'Chair2')
    @project10 = FactoryBot.create(:project, title: 'Project 1_0', chair: @chair1)
    @project11 = FactoryBot.create(:project, title: 'Project 1_1', chair: @chair1)
    @project20 = FactoryBot.create(:project, title: 'Project 2_0', chair: @chair2)

    @project10.users << @user
    @project11.users << @user
    @project20.users << @user

#    @chair1.projects = [@project10, @project11]
#    @chair2.projects = [@project20]

    login_as @user
    visit '/projects'

    expect(page).to have_content(@project10.title)
    expect(page).to have_content(@project11.title)
    expect(page).to have_content(@project20.title)
  end

  it 'should filter by chair' do
    select @chair1.name, from: 'chair'
    click_on I18n.t('links.search')

    expect(page).to have_content(@project10.title)
    expect(page).to have_content(@project11.title)
    expect(page).to_not have_content(@project20.title)
  end

  it 'should search for project title' do
    fill_in 'title', with: '0'
    click_on I18n.t('links.search')

    expect(page).to have_content(@project10.title)
    expect(page).to_not have_content(@project11.title)
    expect(page).to have_content(@project20.title)
  end

  it 'should filter by project title and chair name' do
    select @chair1.name, from: 'chair'
    fill_in 'title', with: '0'
    click_on I18n.t('links.search')

    expect(page).to have_content(@project10.title)
    expect(page).to_not have_content(@project11.title)
    expect(page).to_not have_content(@project20.title)
  end
end
