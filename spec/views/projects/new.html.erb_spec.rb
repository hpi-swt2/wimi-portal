require 'rails_helper'

RSpec.describe 'projects/new', type: :view do
  before(:each) do
    @chair = FactoryGirl.create(:chair)
    @user = FactoryGirl.create(:user)
    @wimi = FactoryGirl.create(:user)
    FactoryGirl.create(:wimi, user: @wimi, chair: @chair)
  end

  # TODO: move to feature tests
#  it 'can be created by a wimi and has afterwards the same chair as the wimi' do
#    login_as @wimi
#    visit projects_path
#    click_on I18n.t('projects.index.new')
#    fill_in 'project_title', with: 'My New Project'
#    click_on I18n.t('projects.form.create_project')
#    expect(page).to have_content(@wimi.chair.name)
#  end
end
