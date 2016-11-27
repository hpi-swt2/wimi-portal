require 'rails_helper'

describe 'time_sheet#show' do
  before :each do
    @hiwi = FactoryGirl.create(:hiwi)
    @wimi = FactoryGirl.create(:wimi).user
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
    @time_sheet = FactoryGirl.create(:time_sheet, contract: @contract)
    @time_sheet_handed_in = FactoryGirl.create(:time_sheet, contract: @contract, handed_in: true, status: 'pending')
    login_as @hiwi
  end

  it 'is possible to hand in an (empty) time sheet as a HiWi' do
    pending "Skipped until #502 is implemented"

    visit time_sheet_path(@time_sheet)
    click_on I18n.t('helpers.links.hand_in')
    expect(page).to have_current_path(time_sheet_path(@time_sheet))
    expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.accepted"))
    expect(page).to have_success_flash_message
    expect(page).to_not have_danger_flash_message
  end

  it 'there is no button to hand in an already handed in time sheet' do
    visit time_sheet_path(@time_sheet_handed_in)
    expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.pending"))
    expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.hand_in'))
  end

  it 'is possible to withdraw a handed in time sheet' do
    pending "Skipped until #502 is implemented"

    visit time_sheet_path(@time_sheet_handed_in)
    click_on I18n.t('helpers.links.withdraw')
    expect(page).to have_current_path(time_sheet_path(@time_sheet_handed_in))
    expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.created"))
    expect(page).to have_success_flash_message
    expect(page).to_not have_danger_flash_message
  end

  it 'a not handed in time sheet does not have a withdraw button' do
    visit time_sheet_path(@time_sheet)
    expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.created"))
    expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.links.withdraw'))
  end
end
