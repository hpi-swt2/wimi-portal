require 'rails_helper'

describe 'time_sheet#show as a HiWi' do
  before :each do
    @hiwi = FactoryGirl.create(:hiwi)
    @wimi = FactoryGirl.create(:wimi).user
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
    login_as @hiwi
  end

  context 'with a "created" time sheet' do
    before :each do
      @time_sheet = FactoryGirl.create(:time_sheet, contract: @contract)
      visit time_sheet_path(@time_sheet)
    end

    it 'is possible to close it' do
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.created"))
      click_on I18n.t('helpers.links.close', model: TimeSheet.model_name.human.titleize)
      expect(page).to have_current_path(time_sheet_path(@time_sheet))
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.closed"))
      expect(page).to have_success_flash_message
      expect(page).to_not have_danger_flash_message
    end

    it 'is not possible to reopen it' do
      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.reopen'))
      expect(page).to_not have_css("*[href='#{reopen_time_sheet_path(@time_sheet)}']")
    end
  end

  context 'with a "closed" time sheet' do
    before :each do
      @time_sheet_closed = FactoryGirl.create(:time_sheet, contract: @contract, status: 'closed')
      visit time_sheet_path(@time_sheet_closed)
    end

    it 'cannot be closed' do
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.closed"))
      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.close', model: TimeSheet.model_name.human.titleize))
      expect(page).to_not have_css("*[href='#{close_time_sheet_path(@time_sheet_closed)}']")
    end

    it 'is possible to reopen a closed time sheet' do
      expect(page).to have_selector(:link_or_button, I18n.t('helpers.links.reopen'))
      click_on I18n.t('helpers.links.reopen')
      expect(page).to have_current_path(time_sheet_path(@time_sheet_closed))
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.created"))
      expect(page).to have_success_flash_message
      expect(page).to_not have_danger_flash_message
    end
  end

  context 'with a "pending" time sheet' do
    before :each do
      @time_sheet_pending = FactoryGirl.create(:time_sheet, contract: @contract, status: 'pending')
      visit time_sheet_path(@time_sheet_pending)
    end

    it 'can be closed' do
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.pending"))
      expect(page).to have_selector(:link_or_button, I18n.t('helpers.links.close', model: TimeSheet.model_name.human.titleize))
    end

    it 'cannot be reopened' do
      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.reopen'))
      expect(page).to_not have_css("*[href='#{reopen_time_sheet_path(@time_sheet_pending)}']")
    end
  end

  context 'with an "accepted" time sheet' do
    before :each do
      @time_sheet_accepted = FactoryGirl.create(:time_sheet, contract: @contract)
      @time_sheet_accepted.accept_as(@wimi)
      visit time_sheet_path(@time_sheet_accepted)
    end

    it 'cannot be closed' do
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.accepted"))
      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.close', model: TimeSheet.model_name.human.titleize))
      expect(page).to_not have_css("*[href='#{close_time_sheet_path(@time_sheet_accepted)}']")
    end

    it 'cannot be reopened' do
      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.reopen'))
      expect(page).to_not have_css("*[href='#{reopen_time_sheet_path(@time_sheet_accepted)}']")
    end
  end

  context 'with a "rejected" time sheet' do
    before :each do
      @time_sheet_rejected = FactoryGirl.create(:time_sheet, contract: @contract)
      @time_sheet_rejected.reject_as(@wimi)
      visit time_sheet_path(@time_sheet_rejected)
    end

    it 'can be closed' do
      expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.rejected"))
      expect(page).to have_selector(:link_or_button, I18n.t('helpers.links.close', model: TimeSheet.model_name.human.titleize))
    end

    it 'cannot be reopened' do
      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.reopen'))
      expect(page).to_not have_css("*[href='#{reopen_time_sheet_path(@time_sheet_rejected)}']")
    end
  end
end

describe 'time_sheet#show as a WiMi' do
  before :each do
    @hiwi = FactoryGirl.create(:hiwi)
    @wimi = FactoryGirl.create(:wimi).user
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
    login_as @wimi
  end

  context 'with a time sheet in the states "created", "pending" and "closed"' do
    it 'cannot be closed' do
      [:created, :pending, :closed].each do |status|
        time_sheet = FactoryGirl.create(:time_sheet, contract: @contract, status: status)
        visit time_sheet_path(time_sheet)
        expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.#{status}"))
        expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.close', model: TimeSheet.model_name.human.titleize))
        expect(page).to_not have_css("*[href='#{close_time_sheet_path(time_sheet)}']")
        time_sheet.destroy
      end
    end

    it 'cannot be reopened' do
      [:created, :pending, :closed].each do |status|
        time_sheet = FactoryGirl.create(:time_sheet, contract: @contract, status: status)
        visit time_sheet_path(time_sheet)
        expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.reopen'))
        expect(page).to_not have_css("*[href='#{reopen_time_sheet_path(time_sheet)}']")
        time_sheet.destroy
      end
    end
  end

  context 'with an "accepted" time sheet' do
    before :each do
      @time_sheet_accepted = FactoryGirl.create(:time_sheet, contract: @contract)
      @time_sheet_accepted.accept_as(@wimi)
      visit time_sheet_path(@time_sheet_accepted)
    end

    it 'cannot be closed' do
      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.close', model: TimeSheet.model_name.human.titleize))
      expect(page).to_not have_css("*[href='#{close_time_sheet_path(@time_sheet_accepted)}']")
    end

    it 'cannot be reopened' do
      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.reopen'))
      expect(page).to_not have_css("*[href='#{reopen_time_sheet_path(@time_sheet_accepted)}']")
    end
  end

  context 'with a "rejected" time sheet' do
    before :each do
      @time_sheet_rejected = FactoryGirl.create(:time_sheet, contract: @contract)
      @time_sheet_rejected.reject_as(@wimi)
      visit time_sheet_path(@time_sheet_rejected)
    end

    it 'cannot be closed' do
      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.close', model: TimeSheet.model_name.human.titleize))
      expect(page).to_not have_css("*[href='#{close_time_sheet_path(@time_sheet_rejected)}']")
    end

    it 'cannot be reopened' do
      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.reopen'))
      expect(page).to_not have_css("*[href='#{reopen_time_sheet_path(@time_sheet_rejected)}']")
    end
  end
end