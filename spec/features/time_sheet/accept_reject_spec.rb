require 'rails_helper'

describe 'time_sheet#show' do
  before :each do
    @hiwi = FactoryGirl.create(:hiwi)
    @wimi = FactoryGirl.create(:wimi).user
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
    @time_sheet = FactoryGirl.create(:time_sheet, contract: @contract, handed_in: true, status: 'pending')
    login_as @wimi
  end

  it 'is possible to accept a time sheet' do
    pending "Skipped until #502 is implemented"

    visit time_sheet_path(@time_sheet)
    expect(page).to have_content(I18n.t('time_sheets.show_footer.accept'))
    find('input[value="accept"]').click
    expect(page).to have_current_path(time_sheet_path(@time_sheet))
    expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.accepted"))
    expect(page).to have_css('div.alert-success')
    expect(page).to_not have_css('div.alert-danger')
  end

  it 'there are no accept / reject buttons for an accepted time sheet' do
    @ts_accepted = FactoryGirl.create(:time_sheet,
      contract: @contract,
      signer: @wimi.id,
      handed_in: true,
      status: 'accepted')
    visit time_sheet_path(@ts_accepted)
    expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.accepted"))
    expect(page).to_not have_selector(:link_or_button, I18n.t('time_sheets.show_footer.accept'))
    expect(page).to_not have_selector(:link_or_button, I18n.t('time_sheets.show_footer.reject'))
  end

  it 'is possible to reject a time sheet' do
    pending "Skipped until #502 is implemented"

    visit time_sheet_path(@time_sheet)
    find('input[value="reject"]').click
    expect(page).to have_current_path(time_sheet_path(@time_sheet))
    expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.rejected"))
    expect(page).to have_css('div.alert-success')
    expect(page).to_not have_css('div.alert-danger')
  end

  it 'there are no accept / reject buttons for a rejected time sheet' do
    @ts_rejected = FactoryGirl.create(:time_sheet,
      contract: @contract,
      signer: @wimi.id,
      handed_in: true,
      status: 'rejected')
    visit time_sheet_path(@ts_rejected)
    expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.rejected"))
    expect(page).to_not have_selector(:link_or_button, I18n.t('time_sheets.show_footer.reject'))
    expect(page).to_not have_selector(:link_or_button, I18n.t('time_sheets.show_footer.accept'))
  end
end