require 'rails_helper'

describe 'time_sheets#show' do
  before :each do
    @contract = FactoryGirl.create(:contract, hours_per_week: 2)
    @time_sheet = FactoryGirl.create(:time_sheet, contract: @contract)
    @expected_monthly_work_time = (@contract.hours_per_week * 4).to_i
    hiwi = @contract.hiwi
    login_as hiwi
  end

  context "with existing work days" do
    before :each do
      @work_hours = 2
      FactoryGirl.create(:work_day, date: @contract.start_date,
        start_time: @contract.start_date.middle_of_day,
        end_time: @contract.start_date.middle_of_day + @work_hours.hours,
        time_sheet: @time_sheet)
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

    it 'displays a table of work_days' do
      within('#main-content') do
        expect(page).to have_css('table#work-days', count: 1)
        # table header is also a <tr> element
        expect(page).to have_css('table#work-days tr', count: WorkDay.count + 1)
        expect(page).to have_css('table#work-days tr th', minimum: 1)
        expect(page).to have_css('table#work-days tr td', minimum: 1)
      end
    end
  end

  context "Without existing work days" do
    before :each do
      visit time_sheet_path(@time_sheet)
    end

    it 'display all work hours as still open' do
      expect(page).to have_content(I18n.t('time_sheets.show.open_work_time'))
      expect(page).to have_content(I18n.t('helpers.timespan.hours',
        hours: @expected_monthly_work_time))
    end

    it 'does not display a table of work_days if none are available' do
      within('#main-content') do
        expect(page).to_not have_css('table#work-days')
        expect(page).to_not have_css('table#work-days tr')
      end
    end

    it 'displays a message that no work_days have been entered yet' do
      within('#main-content') do
        expect(page).to have_content(I18n.t('time_sheets.show.empty_work_days'))
      end
    end
  end

end