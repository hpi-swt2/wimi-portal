require 'rails_helper'

describe 'time_sheets#show' do
  before :each do
    @contract = FactoryGirl.create(:contract, hours_per_week: 2)
    @time_sheet = FactoryGirl.create(:time_sheet, contract: @contract)
    @expected_monthly_work_time = (@contract.hours_per_week * 4.5).to_i
    @work_hours = 2
    FactoryGirl.create(:work_day, date: @contract.start_date,
      start_time: @contract.start_date.middle_of_day,
      end_time: @contract.start_date.middle_of_day + @work_hours.hours,
      time_sheet: @time_sheet)
    hiwi = @contract.hiwi
    login_as hiwi
    visit time_sheet_path(@time_sheet)
  end

  it 'displays the hours and minutes that have been worked already' do
    expect(page).to have_content(I18n.t('time_sheets.show.total_work_time'))
    expect(page).to have_content(I18n.t('helpers.timespan.hours', hours: @work_hours))
  end

  it 'display the hours that are required every month by the contract' do
    expect(page).to have_content(I18n.t('time_sheets.show.expected_work_time'))
    # 2*4.5 = 9
    expect(page).to have_content(I18n.t('helpers.timespan.hours', hours: @expected_monthly_work_time))
  end

  it 'display percentage of achieved hours' do
    percentage = ((@work_hours/@expected_monthly_work_time.to_f)*100).floor
    expect(page).to have_content("#{percentage}%")
    expect(page).to have_content(I18n.t('time_sheets.show.achieved'))
  end

  it 'display still open work hours' do
    expect(page).to have_content(I18n.t('time_sheets.show.open_work_time'))
    expect(page).to have_content(I18n.t('helpers.timespan.hours',
      hours: @expected_monthly_work_time - @work_hours))
  end
end