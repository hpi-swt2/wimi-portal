require 'rails_helper'

RSpec.describe 'projects/show', type: :view do
  before(:each) do
    @chair = FactoryGirl.create(:chair)
  end


  it 'has information about the project on page as a chair representative' do
    representative = FactoryGirl.create(:chair_representative, chair: @chair)
    login_as representative
    project = FactoryGirl.create(:project, chair: representative.chair, status: true)
    representative.projects`                                  ` << project
    visit project_path(project.id)

    expect(page).to have_content(project.title)
    expect(page).to have_content(project.chair.name)
    expect(page).to have_content(project.chair.representative.user.name)
    expect(page).to have_content('Active')
    expect(page).to have_content('Public')
    expect(page).to have_content(representative.name)
  end

  it 'has information about the project on page as a wimi' do
    chair_representative = FactoryGirl.create(:chair_representative, chair: @chair)
    wimi = FactoryGirl.create(:wimi, chair: @chair)

    login_as wimi
    project = FactoryGirl.create(:project, chair: wimi.chair, status: true)
    wimi.projects << project
    visit project_path(project.id)

    expect(page).to have_content(project.title)
    expect(page).to have_content(project.chair.name)
    expect(page).to have_content(project.chair.representative.user.name)
    expect(page).to have_content('Active')
    expect(page).to have_content('Public')
    expect(page).to have_content(wimi.name)
  end

  it 'has information about the project on page as a hiwi' do
    chair_representative = FactoryGirl.create(:chair_representative, chair: @chair)
    hiwi = FactoryGirl.create(:user)

    login_as hiwi
    project = FactoryGirl.create(:project, chair: chair_representative.chair, status: true)
    hiwi.projects << project
    visit project_path(project.id)

    expect(page).to have_content(project.title)
    expect(page).to have_content(project.chair.name)
    expect(page).to have_content(project.chair.representative.user.name)
    expect(page).to have_content('Active')
    expect(page).to have_content('Public')
    expect(page).to have_content(hiwi.name)
  end
  

end