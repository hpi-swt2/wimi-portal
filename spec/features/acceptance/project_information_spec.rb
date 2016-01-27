require 'rails_helper'

feature 'Project information' do
  background do
    user = FactoryGirl.create(:user)
    chair = FactoryGirl.create(:chair)
    representative = FactoryGirl.create(:chair_representative, user: user, chair: chair).user
    @current_user = FactoryGirl.create(:user, language: 'de')
    login_as @current_user
    @project = FactoryGirl.create(:project, chair: representative.chair)
  end

  scenario 'Go on project site' do
    visit project_path(@project)
    expect(page).to have_content('Fachgebiet')
    expect(page).to have_content('Beauftragter des Fachgebiets')
    expect(page).to have_content('Sichtbarkeit')
  end
end
