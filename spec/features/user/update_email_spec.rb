require 'rails_helper'

describe 'updating email address' do
  before :each do
    @user = FactoryBot.create(:user)
    login_as @user
    visit edit_user_path(@user)
  end

  it 'should update with a valid email address' do
    valid_email = 'valid@e.mail.com'
    expect(valid_email).to_not eq(@user.email)
    fill_in :user_email, with: valid_email
    click_button 'Save'
    expect(page).to have_text(valid_email)
  end

  it 'should not update without a valid email address' do
    fill_in :user_email, with: 'invalid mail'
    click_button 'Save'
    expect(page).to have_content(I18n.t('users.no_email'))
    expect(page).to have_danger_flash_message
  end
end
