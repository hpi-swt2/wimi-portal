require 'rails_helper'

RSpec.describe 'projects/index', type: :view do
  before(:each) do
    @chair = FactoryBot.create(:chair)
    @proj1 = FactoryBot.create(:project, :title => 'Proj1', :chair => @chair)
    @proj2 = FactoryBot.create(:project, :title => 'Proj2')
    assign(:projects, [@proj1, @proj2])
    @user = FactoryBot.create(:user)
    login_as @user
    allow(view).to receive(:current_user).and_return(@user)
  end

  it 'renders a list of projects' do
    render
    expect(rendered).to match @proj1.title
    expect(rendered).to match @proj2.title
  end

  it 'shows all details about a project' do
    # In case of only a single project, projects_path redirects to
    # that project's project#show page.
    project = FactoryBot.create(:project, chair: @chair)
    project.users << @user
    another_project = FactoryBot.create(:project, chair: @chair)
    another_project.users << @user
    visit projects_path

    expect(page).to have_current_path(projects_path)
    expect(page).to have_content(project.title)
    expect(page).to have_content(@chair.name)
    expect(page).to have_content(I18n.t('projects.index.status_true'))

    project.update(status: false)

    visit projects_path

    expect(page).to have_content(I18n.t('projects.index.status_false'))
  end
end
