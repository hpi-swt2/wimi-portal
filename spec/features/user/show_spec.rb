require 'rails_helper'

describe 'user#show' do

  context 'for a HiWi' do
    before :each do
      @user = FactoryGirl.create(:user)
      login_as(@user)
    end

    it 'shows minimal details' do
      visit user_path(@user)
      within('body/div.container') do
        expect(page).to have_content @user.first_name
        expect(page).to have_content @user.last_name
        expect(page).to have_content @user.email
      end
    end
  end

  context 'for a WiMi' do
    before :each do
      @chair = FactoryGirl.create(:chair)
      @user = FactoryGirl.create(:wimi, chair: @chair).user
      @project = FactoryGirl.create(:project, chair: @chair)
      @project.users << @user
      login_as(@user)
    end

    it 'shows status, chair and projects' do
      visit user_path(@user)
      expect(page).to have_content @user.first_name
      expect(page).to have_content @user.last_name
      expect(page).to have_content I18n.t('users.private_user_data.wimi')
      expect(page).to have_content @chair.name
      expect(page).to have_content @project.title
    end
  end

end
