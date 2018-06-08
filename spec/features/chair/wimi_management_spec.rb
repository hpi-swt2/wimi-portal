require 'rails_helper'

describe 'chair user management' do
  before :each do
    @chair = FactoryGirl.create(:chair)
    @representative = @chair.representative.user
    @admin = FactoryGirl.create(:wimi, chair: @chair, admin: true).user
    @user1 = FactoryGirl.create(:wimi, chair: @chair).user
  end
  
  it 'should allow representative to remove wimi' do
    login_as @representative
    visit chair_path(@chair)
    
    # click remove-user link
    find("a[href='#{chair_user_path(@chair, @user1)}']").click
    
    expect(page).to_not have_css('#main-content td', text: @user1.name)
  end
  
  it 'should allow representative to set admin' do
    login_as @representative
    visit chair_path(@chair)
    
    # click remove-user link
    click_on I18n.t('chairs.applications.grant_rights')
    
    expect(page).to have_text(@user1.name + " " + I18n.t('roles.admin_long'))
    expect(@user1.reload.is_admin?).to be true
  end
  
  it 'should allow representative to withdraw admin rights' do
    login_as @representative
    visit chair_path(@chair)
    
    # click remove-user link
    click_on I18n.t('chairs.applications.withdraw_rights')
    
    expect(page).to_not have_text(@admin.name + " " + I18n.t('roles.admin_long'))
    expect(@admin.reload.is_admin?).to be false
  end
end
