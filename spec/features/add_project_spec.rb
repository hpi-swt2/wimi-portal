require 'rails_helper'

describe 'the project button on the project index page' do
  it 'is available for wimis' do
    @current_user = FactoryGirl.create(:wimi)
    login_as @current_user
    print (@current_user.chair)
    visit projects_path
    click_on I18n.t('projects.new')
    expect(current_path).to eq(new_project_path)
  end

  it 'is not available for hiwis' do
    login_as FactoryGirl.create(:hiwi)
    visit projects_path
    expect(page).to_not have_text I18n.t('projects.new')
  end

  it 'is not available for superadmins' do
    login_as FactoryGirl.create(:superadmin)
    visit projects_path
    expect(page).to_not have_text I18n.t('projects.new')
  end
end