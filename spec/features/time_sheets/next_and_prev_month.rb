require 'rails_helper'

describe 'time_sheet#show' do
  before :each do
    @user = FactoryGirl.create(:user)
    @contract = FactoryGirl.create(:contract, hiwi: @user)
    @time_sheet = FactoryGirl.create(:time_sheet, contract: @contract, month: 12)
    @time_sheet_next = FactoryGirl.create(:time_sheet, contract: @contract, month: @time_sheet.next_month)
    @time_sheet_prev = FactoryGirl.create(:time_sheet, contract: @contract, month: @time_sheet.previous_month)
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

    expect(page).to have_content('1')
    expect(page).to have_content(@time_sheet.next_year)
    expect(page).to have_content("New")
  end

end