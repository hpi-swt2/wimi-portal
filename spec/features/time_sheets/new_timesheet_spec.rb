require 'rails_helper'

describe 'Using time_sheets#new' do
  before :each do
    @hiwi = FactoryGirl.create(:hiwi)
    @wimi = FactoryGirl.create(:wimi).user
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
    login_as @hiwi
  end

  it 'is possible to add a new work sheet' do
    visit new_contract_time_sheet_path(@contract)

    fill_in "time_sheet_month", with: Date.today.month
    fill_in "time_sheet_year", with: Date.today.year

    ts_count_before = TimeSheet.count
    find('#hiddensubmit').click
    expect(TimeSheet.count).to eq(ts_count_before+1)
    # No flash error
    expect(page).to_not have_css('div.alert-danger')
  end
end