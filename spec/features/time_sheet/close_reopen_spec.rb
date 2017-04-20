require 'rails_helper'

describe 'time_sheet#show' do
  before :each do
    @hiwi = FactoryGirl.create(:hiwi)
    @wimi = FactoryGirl.create(:wimi).user
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
    login_as @hiwi
  end

  context 'with a time sheet' do
    before :each do
      @time_sheet = FactoryGirl.create(:time_sheet, contract: @contract)
    end

    it 'is possible to close a time sheet as a HiWi' do
      visit time_sheet_path(@time_sheet)
      expect(page).to have_selector(:link_or_button, I18n.t('helpers.links.close'))
      click_on I18n.t('helpers.links.close')
      expect(page).to have_current_path(time_sheet_path(@time_sheet))
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.closed"))
      expect(page).to have_success_flash_message
      expect(page).to_not have_danger_flash_message
    end

    it 'has no reopen button' do
      visit time_sheet_path(@time_sheet)
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.created"))
      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.reopen'))
    end
  end

  context 'with a closed time sheet' do
    before :each do
      @time_sheet_closed = FactoryGirl.create(:time_sheet, contract: @contract, status: 'closed')
    end

    it 'has no close button' do
      visit time_sheet_path(@time_sheet_closed)
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.closed"))
      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.close'))
    end

    it 'is possible to reopen a closed time sheet' do
      visit time_sheet_path(@time_sheet_closed)
      expect(page).to have_selector(:link_or_button, I18n.t('helpers.links.reopen'))
      click_on I18n.t('helpers.links.reopen')
      expect(page).to have_current_path(time_sheet_path(@time_sheet_closed))
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.created"))
      expect(page).to have_success_flash_message
      expect(page).to_not have_danger_flash_message
    end
  end
end
