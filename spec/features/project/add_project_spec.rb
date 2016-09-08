require 'rails_helper'

describe 'the project button on the project index page' do
  it 'is available for wimis' do
    @current_user = FactoryGirl.create(:wimi, user: FactoryGirl.create(:user), chair: FactoryGirl.create(:chair), representative: true).user
    login_as @current_user
    visit projects_path
    click_on I18n.t('helpers.titles.new', model: Project.model_name.human.titleize)
    expect(current_path).to eq(new_project_path)
  end

  it 'is not available for hiwis' do
    login_as FactoryGirl.create(:hiwi)
    visit projects_path
    expect(page).to_not have_text I18n.t('helpers.links.new')
  end
end
