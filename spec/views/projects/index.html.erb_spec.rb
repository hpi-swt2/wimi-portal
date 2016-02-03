require 'rails_helper'

RSpec.describe 'projects/index', type: :view do
  before(:each) do
    assign(:projects, [
      FactoryGirl.create(:project),
      FactoryGirl.create(:project)
    ])
    @user = FactoryGirl.create(:user)
    login_as @user
  end

  it 'renders a list of projects' do
    render
  end

  it 'shows all details about a project' do
    chair = FactoryGirl.create(:chair)
    project = FactoryGirl.create(:project, chair: chair)

    project.update(status: true)
    project.update(public: true)

    visit projects_path

    expect(page).to have_content(project.title)
    expect(page).to have_content(l(project.created_at))
    expect(page).to have_content(chair.name)

    expect(page).to have_content(I18n.t('projects.index.public'))
    expect(page).to have_content(I18n.t('projects.index.active'))

    project.update(status: false)
    project.update(public: false)
    visit projects_path

    expect(page).to have_content(I18n.t('projects.index.inactive'))
    expect(page).to have_content(I18n.t('projects.index.private'))
  end

  it 'denys the superadmin the the list of projects' do
    superadmin = FactoryGirl.create(:user, superadmin: true)
    login_as superadmin
    visit projects_path
    expect(current_path).to eq(dashboard_path)
  end
end
