require 'rails_helper'

describe 'updating email address' do
  before :each do
    @user = FactoryGirl.create(:user)
    login_as @user
    visit edit_user_path(@user.id)
  end

  it 'should update with a valid email address' do
    valid_email = 'valid@e.mail'
    fill_in :user_email, with: valid_email
    click_button 'Save'
    expect(@user.reload.email).to eq(valid_email)
  end

  it 'should not update without a valid email address' do
    former_mail = @user.email
    fill_in :user_email, with: 'invalid mail'
    click_button 'Save'
    expect(page).to have_text(I18n.t('users.no_email'))
    fill_in :user_email, with: 'invalid.mail'
    click_button 'Save'
    expect(page).to have_text(I18n.t('users.no_email'))
    fill_in :user_email, with: 'invalid@mail'
    click_button 'Save'
    expect(page).to have_text(I18n.t('users.no_email'))
    expect(@user.reload.email).to eq(former_mail)
  end
end
