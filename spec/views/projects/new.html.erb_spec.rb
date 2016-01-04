require 'rails_helper'

RSpec.describe 'projects/new', type: :view do
  before(:each) do
    @chair = FactoryGirl.create(:chair)
  end

  it 'can be created by a wimi and has afterwards the same chair as the wimi' do
    chair_representative = FactoryGirl.create(:chair_representative, chair: @chair)
    wimi = FactoryGirl.create(:wimi, chair: @chair)
    login_as wimi
    visit projects_path
    click_on 'New'
    fill_in 'project_title', with: 'My New Project'
    click_on 'Create Project'
    expect(page).to have_content(wimi.chair.name)

  end

end
