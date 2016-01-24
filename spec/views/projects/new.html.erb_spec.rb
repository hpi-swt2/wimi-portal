require 'rails_helper'

RSpec.describe 'projects/new', type: :view do
  before(:each) do
    @chair = FactoryGirl.create(:chair)
    @user = FactoryGirl.create(:user)
    @wimi_user = FactoryGirl.create(:user)
  end

  it 'can be created by a wimi and has afterwards the same chair as the wimi' do
    chair_representative = FactoryGirl.create(:chair_representative, user: @user, chair: @chair)
    wimi = FactoryGirl.create(:wimi, user: @wimi_user, chair: @chair).user
    login_as wimi
    visit projects_path
    click_on I18n.t('projects.index.new')
    fill_in 'project_title', with: 'My New Project'
    click_on I18n.t('projects.form.create_project')
    expect(page).to have_content(wimi.chair.name)
  end
end
