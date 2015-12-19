require 'rails_helper'

RSpec.describe 'projects/show', type: :view do
  before(:each) do
    @chair = FactoryGirl.create(:chair)
    @representative = FactoryGirl.create(:chair_representative, chair: @chair)
    @user = FactoryGirl.create(:user)
  end


  it 'has information about the project on page as a chair representative' do
    login_as @representative
    project = FactoryGirl.create(:project, chair: @representative.chair, status: true)
    visit project_path(project.id)

    expect(page).to have_content(project.title)
    expect(page).to have_content(project.chair.name)
    expect(page).to have_content(project.chair.representative.user.name)
    expect(page).to have_content('Active')
    expect(page).to have_content('Public')
    expect(page).to have_content(@representative.name)
  end
  

end