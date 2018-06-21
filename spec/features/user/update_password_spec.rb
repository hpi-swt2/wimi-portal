require 'rails_helper'

feature 'password updating' do
  before :each do
    @user = FactoryBot.create(:user, username: 'admin', password: 'myadminpassword')
    @old_encrypted_password = @user.encrypted_password

    login_as @user
    visit edit_user_path(@user)
    expect(page).to have_content I18n.t('users.edit.password')
  end

  it 'should update with valid current password' do
    fill_in 'user_current_password', with: @user.password
    fill_in 'user_password', with: 'newpassword'
    fill_in 'user_password_confirmation', with: 'newpassword'
    click_on I18n.t('users.show.update_password')

    expect(page).to have_content I18n.t('devise.registrations.updated')
    @user.reload
    expect(@user.encrypted_password).to_not eq @old_encrypted_password
  end

  it 'should not update with invalid current password' do
    fill_in 'user_current_password', with: 'invalid_current_password'
    fill_in 'user_password', with: 'newpassword'
    fill_in 'user_password_confirmation', with: 'newpassword'
    click_on I18n.t('users.show.update_password')

    @user.reload
    expect(@user.encrypted_password).to eq @old_encrypted_password
    expect(page).to_not have_content I18n.t('devise.registrations.updated')
  end

  it 'should not update with invalid password confirmation' do
    fill_in 'user_current_password', with: @user.password
    fill_in 'user_password', with: 'newpassword'
    fill_in 'user_password_confirmation', with: 'invalid_password_confirmation'
    click_on I18n.t('users.show.update_password')

    @user.reload
    expect(@user.encrypted_password).to eq @old_encrypted_password
    expect(page).to_not have_content I18n.t('devise.registrations.updated')
  end

  it 'should login with the new password' do
    click_on I18n.t('helpers.application_tabs.logout')

    @user.update(password: 'thenewpassword')
    visit external_login_path

    fill_in 'user_username', with: @user.username
    fill_in 'user_password', with: 'thenewpassword'
    click_on I18n.t('users.external_login.login')

    expect(page).to_not have_content I18n.t('users.external_login.login')
    expect(page).to have_content I18n.t('helpers.application_tabs.logout')
  end
end

describe 'password updating for other users' do
  it 'should not show the password fields for other users' do
    user = FactoryBot.create(:user, username: nil)
    login_as user
    visit edit_user_path(user)
    expect(page).to_not have_content 'Change Password'
  end
end
