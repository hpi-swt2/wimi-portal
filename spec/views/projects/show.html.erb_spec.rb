require 'rails_helper'

RSpec.describe 'projects/show', type: :view do
  before(:each) do

    # @wimi = FactoryGirl.create(:chair_representative, first_name:'Theresa', last_name:'Zobel', superadmin: true)
    # @user = FactoryGirl.create(:user)
    # @project = assign(:project, Project.create!(:title => 'My Project'))
  end


  it 'has information about the project on page as a Wimi' do
    @wimi = FactoryGirl.create(:chair_representative, first_name:'Theresa', last_name:'Zobel', superadmin: true)
    login_as @wimi
    @project = FactoryGirl.create(:project, title:'BP1', chair: @wimi.chair, project_leader:'')
    # byebug
    visit "/projects/#{@project.id}"
    # print page.html

    # expect(page).to have_content(@project.title)
    # expect(page).to have_content(@project.chair.name)
    # expect(page).to have_content(@project.chair.representative.user.name)
    # expect(page).to have_content(@project.status)
    # expect(page).to have_content(@project.public)
    # expect(page).to have_content(@wimi.name)
  end


  # it 'has information about the project on page as Hiwi' do
  #   login_as @wimi
  #   visit @project.id
  #   expect(page).to have_content(@project.title)
  #   expect(page).to have_content(@project.chair.name)
  #   expect(page).to have_content(@project.chair.representative.user.name)
  #   expect(page).to have_content(@project.status)
  #   expect(page).to have_content(@project.public)
  #   expect(page).to have_content(@wimi.name)
  # end

  # it 'has the accessibility public after a project was newly created' do
  #   project2 = FactoryGirl.create(:project)
  #   visit "/projects/#{project2.id}/edit"
  #   expect(page).to have_selector 'input[type=radio][checked=checked][id=project_public_true]'
  # end
  #
  # it 'has the status active after a project was newly created' do
  #   project3 = FactoryGirl.create(:project)
  #   visit "/projects/#{project3.id}/edit"
  #   expect(page).to have_selector 'input[type=radio][checked=checked][id=project_status_true]'
  # end

end