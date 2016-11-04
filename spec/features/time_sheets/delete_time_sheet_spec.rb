require 'rails_helper'

describe 'Using time_sheets#edit' do
  before :each do
    @hiwi = FactoryGirl.create(:hiwi)
    @wimi = FactoryGirl.create(:wimi).user
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
    @time_sheet = FactoryGirl.create(:time_sheet, contract: @contract)
    login_as @hiwi
  end

  it 'is possible to delete an empty time sheet' do
    visit edit_time_sheet_path(@time_sheet)
    expect(@time_sheet.work_days.count).to eq(0)

    ts_count_before = TimeSheet.count
    # find('a[data-method=delete]').click
    find('#delete').click
    # No flash error
    expect(page).to_not have_css('div.alert-danger')
    expect(TimeSheet.count).to eq(ts_count_before-1)
  end

  it 'is possible to delete a time sheet with work days' do
    FactoryGirl.create(:work_day, time_sheet: @time_sheet, date: Date.today.beginning_of_month)
    FactoryGirl.create(:work_day, time_sheet: @time_sheet, date: Date.today.beginning_of_month + 1.day)
    expect(@time_sheet.work_days.count).to eq(2)
    visit edit_time_sheet_path(@time_sheet)

    ts_count_before = TimeSheet.count
    # find('a[data-method=delete]').click
    find('#delete').click
    # No flash error
    expect(page).to_not have_css('div.alert-danger')
    expect(TimeSheet.count).to eq(ts_count_before-1)
  end
end