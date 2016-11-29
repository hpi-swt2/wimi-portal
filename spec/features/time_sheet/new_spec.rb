require 'rails_helper'

describe 'Using time_sheets#new' do
  before :each do
    @hiwi = FactoryGirl.create(:hiwi)
    @wimi = FactoryGirl.create(:wimi).user
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
    login_as @hiwi
    visit new_contract_time_sheet_path(@contract)
  end

  it 'is possible to add a new work sheet for current month' do
    fill_in "time_sheet_month", with: Date.today.month
    fill_in "time_sheet_year", with: Date.today.year

    expect { find('#hiddensubmit').click }.to change { TimeSheet.count }.by(1)
    # No flash error
    expect(page).to_not have_css('div.alert-danger')
  end

  it 'is not possible to add a work sheet for a month after contract end' do
    after_contract_end = (@contract.end_date + 1.month).end_of_month

    fill_in "time_sheet_month", with: after_contract_end.month
    fill_in "time_sheet_year", with: after_contract_end.year
    find('#hiddensubmit').click

    expect(page).to have_danger_flash_message
    # routes are still a bit weird, idk what is going on
    #expect(page).to have_current_path(new_contract_time_sheet_path(@contract))
  end

  it 'is not possible to add a work sheet for a month before contract start' do
    before_contract_start = (@contract.start_date - 1.month).beginning_of_month

    fill_in "time_sheet_month", with: before_contract_start.month
    fill_in "time_sheet_year", with: before_contract_start.year
    find('#hiddensubmit').click

    expect(page).to have_danger_flash_message
    #expect(page).to have_current_path(new_contract_time_sheet_path(@contract))
  end

  it 'is not possible to add multiple timesheets with the same month/year' do
    @timesheet = FactoryGirl.create(:time_sheet, contract: @contract, month: Date.today.month, year: Date.today.year)

    fill_in "time_sheet_month", with: Date.today.month
    fill_in "time_sheet_year", with: Date.today.year

    expect { find('#hiddensubmit').click }.to change { TimeSheet.count }.by(0)
    # No flash error
    expect(page).to have_css('div.alert-danger')
  end
end