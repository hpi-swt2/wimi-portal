require 'rails_helper'
#require 'spec_helper'
require 'cancan/matchers'

describe 'dashboard#index' do
  context 'for a hiwi without a project' do
    before :each do
      @user = FactoryGirl.create(:user)
      @contract = FactoryGirl.create(:contract, hiwi: @user)
      expect(@user.projects.count).to eq(0)
      login_as @user
    end
    
    it 'does not link to timesheet#current' do
      visit dashboard_path
      
      expect(page).not_to have_selector(:linkhref, current_time_sheets_path)
    end
    
    it 'does not link to timesheet#new' do
      visit dashboard_path
      
      expect(page).not_to have_selector(:linkhref, new_contract_time_sheet_path(@contract))
      within("div#contract") do
        expect(page).not_to have_selector(:submit,"")
      end
    end
  end
end

describe 'contracts#index' do
  context 'for a hiwi without a project' do
    before :each do
      @user = FactoryGirl.create(:user)
      @contract = FactoryGirl.create(:contract, hiwi: @user)
      expect(@user.projects.count).to eq(0)
      login_as @user
    end
    
    it 'does not link to timesheet#current' do
      visit contract_path(@contract)
      
      expect(page).not_to have_selector(:linkhref, current_time_sheets_path)
    end
    
    it 'does not link to timesheet#new' do
      visit contract_path(@contract)
      
      expect(page).not_to have_selector(:linkhref, new_contract_time_sheet_path(@contract))
    end
  end
end

describe 'ability for a user without a project' do
  before :each do
    @user = FactoryGirl.create(:user)
    @contract = FactoryGirl.create(:contract, hiwi: @user)
    expect(@user.projects.count).to eq(0)
  end
  
  it 'does not permit creating a new timesheet' do
    ability = Ability.new(@user)
    
    expect(ability).to_not be_able_to(:new, TimeSheet)
  end
end
