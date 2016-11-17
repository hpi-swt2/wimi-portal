require 'rails_helper'

feature 'user#edit' do
  before :each do
    @user = FactoryGirl.create(:user)
    login_as(@user)
    visit edit_user_path(@user)
  end

  it 'allows adding a personal address' do
    new_street = 'August-Bebel-Str. 89'
    new_zip = '14482'
    new_city = 'Potsdam'
    fill_in('Street', with: new_street)
    fill_in('Zip Code', with: new_zip)
    fill_in('City', with: new_city)
    find('input[type="submit"]').click
    expect(page).to have_css('div.alert-success')
    expect(page).to have_content new_street
    expect(page).to have_content new_zip
    expect(page).to have_content new_street
  end

  it 'does not allow to change the research group' do
    within('form.edit_user') do
      expect(page).to_not have_content I18n.t('activerecord.attributes.user.chair')
    end
  end
end
