require 'rails_helper'

describe 'time_sheet#show' do
  before :each do
    @user = FactoryGirl.create(:user)
    start_date = Date.today << 1
    end_date = Date.today >> 5
    @contract = FactoryGirl.create(:contract, hiwi: @user, start_date: start_date, end_date: end_date)
    @time_sheet = FactoryGirl.create(:time_sheet, contract: @contract, month: 12)
    @time_sheet_next = FactoryGirl.create(:time_sheet, contract: @contract, month: @time_sheet.next_date[:month], year: @time_sheet.next_date[:year])
    @time_sheet_prev = FactoryGirl.create(:time_sheet, contract: @contract, month: @time_sheet.previous_date[:month], year: @time_sheet.previous_date[:year])
    login_as @user
  end

  it 'has a button for next page' do
    visit time_sheet_path(@time_sheet)

    expect(page).to have_content(I18n.t('time_sheets.show.next_month'))

    click_on I18n.t('time_sheets.show.next_month')

    expect(current_path).to eq(time_sheet_path(@time_sheet_next))
  end

  it 'has a button for previous page' do
    visit time_sheet_path(@time_sheet)

    expect(page).to have_content(I18n.t('time_sheets.show.previous_month'))

    click_on I18n.t('time_sheets.show.previous_month')

    expect(current_path).to eq(time_sheet_path(@time_sheet_prev))
  end

  it 'has a button to create a sheet for next month if it doesnt exist yet' do
    @time_sheet_next.destroy

    visit time_sheet_path(@time_sheet)

    expect(page).to have_content(I18n.t('time_sheets.show.create_next_month'))

    click_on I18n.t('time_sheets.show.create_next_month')

    expect(page).to have_content("New")
  end

  it 'has no button to create a sheet for next month if there is no contract for that month' do
    @time_sheet_next.destroy
    @contract.destroy
    start_date = Date.today << 1
    end_date = Date.today >> 5
    @contract = FactoryGirl.create(:contract, hiwi: @user, start_date: start_date, end_date: end_date)
    @time_sheet.contract = @contract

    visit time_sheet_path(@time_sheet)

    expect(page).not_to have_content(I18n.t('time_sheets.show.create_next_month'))
  end
end