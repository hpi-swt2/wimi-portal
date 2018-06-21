require 'rails_helper'

describe 'time_sheet#show' do
  before :each do
    @hiwi = FactoryBot.create(:hiwi)
    @wimi = FactoryBot.create(:wimi).user
    @contract = FactoryBot.create(:contract, hiwi: @hiwi, responsible: @wimi)
    login_as @hiwi
  end

  context 'with new time sheet' do
    before :each do
      @time_sheet = FactoryBot.create(:time_sheet, contract: @contract)
    end

    it 'is possible to hand in an (empty) time sheet as a HiWi' do
      visit time_sheet_path(@time_sheet)
      expect(page).to have_selector(:link_or_button, I18n.t('helpers.links.hand_in'))
      click_on I18n.t('helpers.links.hand_in')
      expect(page).to have_current_path(time_sheet_path(@time_sheet))
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.pending"))
      expect(page).to have_success_flash_message
      expect(page).to_not have_danger_flash_message
    end

    it 'a not handed in time sheet does not have a withdraw button' do
      visit time_sheet_path(@time_sheet)
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.created"))
      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.withdraw'))
    end

    # https://github.com/hpi-swt2/wimi-portal/issues/511
    it 'is possible to sign the sheet as a HiWi when handing in' do
      @hiwi.update_attribute(:signature, 'hiwi_signature')
      visit time_sheet_path(@time_sheet)
      expect(page).to have_selector(:checkbox, I18n.t('time_sheets.hand_in.add_signature'))
      check I18n.t('time_sheets.hand_in.add_signature')
      click_on I18n.t('helpers.links.hand_in')
      expect(page).to have_content(I18n.t('time_sheets.show.hiwi_signed_true_html'))
    end

    # https://github.com/hpi-swt2/wimi-portal/issues/511
    it 'is not possible to sign a sheet as a HiWi if no signature is present' do
      @hiwi.update_attribute(:signature, nil)
      visit time_sheet_path(@time_sheet)
      expect(page).to have_selector(:checkbox, I18n.t('time_sheets.hand_in.add_signature'), disabled: true)
      click_on I18n.t('helpers.links.hand_in')
      expect(page.body).to include(I18n.t('time_sheets.show.hiwi_signed_false_html'))
    end

    it 'does not render information on HiWi signature in the main panel for not handed in sheets' do
      visit time_sheet_path(@time_sheet)
      within '#main-content' do
        false_html = I18n.t('time_sheets.show.hiwi_signed_false_html')
        expect(page.body).to_not include(false_html)
        true_html = I18n.t('time_sheets.show.hiwi_signed_true_html')
        expect(page.body).to_not include(true_html)
      end
    end
  end

  context 'with handed in time sheet' do
    before :each do
      @time_sheet_handed_in = FactoryBot.create(:time_sheet, contract: @contract, handed_in: true, status: 'pending')
    end

    it 'there is no button to hand in an already handed in time sheet' do
      visit time_sheet_path(@time_sheet_handed_in)
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.pending"))
      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.hand_in'))
    end

    it 'is possible to withdraw a handed in time sheet' do
      visit time_sheet_path(@time_sheet_handed_in)
      expect(page).to have_selector(:link_or_button, I18n.t('helpers.links.withdraw'))
      click_on I18n.t('helpers.links.withdraw')
      expect(page).to have_current_path(time_sheet_path(@time_sheet_handed_in))
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.created"))
      expect(page).to have_success_flash_message
      expect(page).to_not have_danger_flash_message
    end

    it 'is possible to resubmit a withdrawn time sheet' do
      @time_sheet_handed_in.update(signed: true)
      visit time_sheet_path(@time_sheet_handed_in)
      click_on I18n.t('helpers.links.withdraw')
      expect(page).to have_selector(:link_or_button, I18n.t('helpers.links.hand_in'))
      click_on I18n.t('helpers.links.hand_in')
      expect(page).to have_current_path(time_sheet_path(@time_sheet_handed_in))
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.pending"))
      expect(page).to have_success_flash_message
      expect(page).to_not have_danger_flash_message
    end

    it 'renders information on HiWi signature in the main panel for handed in sheets' do
      visit time_sheet_path(@time_sheet_handed_in)
      within '#main-content' do
        html = I18n.t('time_sheets.show.hiwi_signed_false_html')
        expect(page.body).to include(html)
      end
      @time_sheet_handed_in.update_attributes(user_signature: 'sig', signed: true, user_signed_at: Date.today)
      visit time_sheet_path(@time_sheet_handed_in)
      within '#main-content' do
        html = I18n.t('time_sheets.show.hiwi_signed_true_html')
        expect(page.body).to include(html)
      end
    end
  end
end
