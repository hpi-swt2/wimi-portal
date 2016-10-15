require 'rails_helper'

#this should work but it doesnt. feature works but test is broken. help please.

describe 'time_sheets#show' do
  before :each do
    @hiwi = FactoryGirl.create(:hiwi)
    @wimi = FactoryGirl.create(:wimi).user
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
    @time_sheet_new = FactoryGirl.create(:time_sheet, contract: @contract)
    @time_sheet_handed_in = FactoryGirl.create(:time_sheet, contract: @contract, handed_in: true)
    login_as @hiwi
  end

  context 'with a new time sheet' do
    it 'has a delete button' do
      visit time_sheet_path(@time_sheet_new)
      
      expect(page).to have_content('Delete')
    end
  end

  context 'with a handed in time sheet' do
    it 'does not have a delete button' do
      visit time_sheet_path(@time_sheet_handed_in)

      expect(page).to_not have_content('Delete')
    end
  end
end