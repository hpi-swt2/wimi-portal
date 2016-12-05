require 'rails_helper'

RSpec.describe 'projects/index', type: :view do
  before(:each) do
    @chair = FactoryGirl.create(:chair)
    @proj1 = FactoryGirl.create(:project, :title => 'Proj1', :chair => @chair)
    @proj2 = FactoryGirl.create(:project, :title => 'Proj2')
    assign(:projects, [@proj1, @proj2])
    @user = FactoryGirl.create(:user)
    login_as @user
    allow(view).to receive(:current_user).and_return(@user)
  end

  it 'renders a list of projects' do
    render
    expect(rendered).to match @proj1.title
    expect(rendered).to match @proj2.title
  end

  it 'does not show private projects that I do not belong to' do
    chair2 = FactoryGirl.create(:chair)
    @user.update(chair: @chair)
    not_my_project = FactoryGirl.create(:project, title: 'I should not see this project', public: false, chair: chair2)

    visit projects_path

    expect(page).to_not have_content(not_my_project.title)
  end

  it 'shows private projects that I do not belong to if I am representative of the chair' do
    @user.update(chair: @chair)
    FactoryGirl.create(:wimi, user: @user, representative: true)
    not_my_project = FactoryGirl.create(:project, title: 'I should not see this project', public: false, chair: @chair)

    visit projects_path

    expect(page).to have_content(not_my_project.title)
  end

  it 'shows private projects that I belong to' do
    @user.update(chair: @chair)
    my_project = FactoryGirl.create(:project, title: 'I should see this project', public: false, chair: @chair)
    my_project.users << @user

    visit projects_path

    expect(page).to have_content(my_project.title)
  end

  it 'shows all details about a project' do
    # In case of only a single project, projects_path redirects to
    # that project's project#show page.
    project = FactoryGirl.create(:project, chair: @chair)
    project.users << @user
    another_project = FactoryGirl.create(:project, chair: @chair)
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
