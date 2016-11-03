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
    it 'does not have a withdraw button' do
      visit time_sheet_path(@time_sheet_new)
      
      expect(page).to_not have_content('Withdraw')
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.created"))
    end
  end

  context 'with a handed in time sheet' do
    it 'has a withdraw button' do
      visit time_sheet_path(@time_sheet_handed_in)

      expect(page).to have_content(I18n.t('helpers.links.withdraw'))
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.pending"))
    end

    it 'can withdraw the time sheet' do
      visit time_sheet_path(@time_sheet_handed_in)

      click_on I18n.t('helpers.links.withdraw')

      @time_sheet_handed_in.reload
      expect(@time_sheet_handed_in.handed_in).to be false

      visit time_sheet_path(@time_sheet_handed_in)

      expect(page).to_not have_content(I18n.t('helpers.links.withdraw'))
    end
  end
end