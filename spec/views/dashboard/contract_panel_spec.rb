require 'rails_helper'

describe 'dashboard/index' do
  
  before :each do
    # create hiwi, contract
    @chair = FactoryGirl.create(:chair)
    @start_date = Date.today << 1
    @end_date = Date.today
    @wimi = FactoryGirl.create(:wimi, chair: @chair).user
    @contract = FactoryGirl.create(:contract, chair: @chair, start_date: @start_date, end_date: @end_date, responsible: @wimi)
    @hiwi = @contract.hiwi
  end
  
  context 'A hiwis dashboard' do
    before :each do
      login_as @hiwi
    end

    it 'displays contracts that are at most 2 months old' do
      visit dashboard_path
      expect(page).to have_selector(:css, "#contract#{@contract.id}")
    end
    
    it 'does not display contracts that have expired more than 3 months ago' do
      contract = FactoryGirl.create(:contract, chair: @chair, start_date: Date.today << 4, end_date: Date.today << 3, responsible: @wimi, description: "Old contract")
      visit dashboard_path
      expect(page).not_to have_selector(:css, "#contract#{contract.id}")
    end
  end
end
