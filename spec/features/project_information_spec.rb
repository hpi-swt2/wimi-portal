require 'rails_helper'

  feature "Project information" do
    background do
      @current_user = FactoryGirl.create(:user)
      login_as @current_user
    end

    scenario "Go on project site" do
      visit @project
      expect(page).to have_content('Fachgebiet')
      expect(page).to have_content('Beauftragter des Fachgebiets')
      expect(page).to have_content('Sichtbarkeit')
      expect(page).to have_content('Teamleiter')
  end
end