require 'rails_helper'
require 'cancan/matchers'

describe 'dashboard#index' do
  before :each do
    @user = FactoryBot.create(:user)
    @contract = FactoryBot.create(:contract, hiwi: @user)
    login_as @user
  end

  context 'for a hiwi without a project' do
    before :each do
      expect(@user.projects.count).to eq(0)
      visit dashboard_path
    end
    
    it 'does not link to timesheet#current' do
      expect(page).not_to have_selector(:linkhref, current_time_sheets_path)
    end
    
    it 'does not link to timesheet#new' do
      expect(page).not_to have_selector(:linkhref, new_contract_time_sheet_path(@contract))
      within("div#contract#{@contract.id}") do
        expect(page).not_to have_selector(:submit)
      end
    end
  end

  context 'for a hiwi with a contract and a project' do
    before :each do
      @project = FactoryBot.create(:project, chair: @contract.chair)
      @user.projects << @project
      visit dashboard_path
    end

    it 'links to timesheet#current' do
      expect(page).to have_selector(:linkhref, current_time_sheets_path)
    end

    it 'links to timesheet#new' do
      within("div#contract#{@contract.id}") do
        expect(page).to have_selector(:submit)
      end
    end
  end
end

describe 'contracts#index' do
  before :each do
    @user = FactoryBot.create(:user)
    @contract = FactoryBot.create(:contract, hiwi: @user)
    login_as @user
  end

  context 'for a hiwi without a project' do
    before :each do
      expect(@user.projects.count).to eq(0)
      visit contract_path(@contract)
    end
    
    it 'does not link to timesheet#current' do
      expect(page).not_to have_selector(:linkhref, current_time_sheets_path)
    end
    
    it 'does not link to timesheet#new' do
      expect(page).not_to have_selector(:linkhref, new_contract_time_sheet_path(@contract))
      within("#timesheet_table") do
        expect(page).not_to have_selector(:submit)
      end
    end
  end

  context 'for a hiwi with a contract and a project' do
    before :each do
      @project = FactoryBot.create(:project, chair: @contract.chair)
      @user.projects << @project
      visit contract_path(@contract)
    end

    it 'links to timesheet#new within sidebar' do
      expect(page.find('#sidebar-content')).to have_selector(:linkhref, new_contract_time_sheet_path(@contract))
    end

    it 'links to timesheet#new within table' do
      within("#timesheet_table") do
        expect(page).to have_selector(:submit)
      end
    end
  end
end

describe 'ability for a user without a project' do
  before :each do
    @user = FactoryBot.create(:user)
    @contract = FactoryBot.create(:contract, hiwi: @user)
    expect(@user.projects.count).to eq(0)
  end
  
  it 'does not permit creating a new timesheet' do
    ability = Ability.new(@user)
    
    expect(ability).to_not be_able_to(:new, TimeSheet)
  end
end

describe 'ability for a user with a contract and a project' do
  before :each do
    @user = FactoryBot.create(:user)
    @contract = FactoryBot.create(:contract, hiwi: @user)
    @user.projects << FactoryBot.create(:project, chair: @contract.chair)
    expect(@user.projects.count).to eq(1)
  end

  it 'permits creating a new timesheet' do
    ability = Ability.new(@user)
    
    expect(ability).to be_able_to(:new, TimeSheet)
  end
end
