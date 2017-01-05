require 'rails_helper'

describe 'A representatives dashboard' do
  before :each do
    #create representative, hiwi, contract
    @chair = FactoryGirl.create(:chair)
    @representative = FactoryGirl.create(:representative, chair: @chair).user
    @start_date = Date.today << 1
    @end_date = Date.today
    @contract = FactoryGirl.create(:contract, chair: @chair, start_date: @start_date, end_date: @end_date)
    login_as @representative
  end

  context "with no missing timesheets" do
    before :each do
      @timesheet1 = FactoryGirl.create(:time_sheet_accepted, contract: @contract, month: @start_date.month, year: @start_date.year)
      @timesheet1 = FactoryGirl.create(:time_sheet_accepted, contract: @contract, month: @end_date.month, year: @end_date.year)
    end

    it 'shows the no entries yet message' do
      visit dashboard_path
      expect(page.find('#missing_timesheets')).to have_content(I18n.t('no_entries_yet', target: I18n.t('activerecord.models.time_sheet.other')))
    end
  end

  context 'with missing timesheets' do
    before :each do
      visit dashboard_path
      @page_section = page.find('#missing_timesheets')
    end

    it 'shows missing timesheets for past months' do
      expect(@page_section.all('.col-md-3').first).to have_content(I18n.l(@start_date, format: :short_month_year))
      expect(@page_section).to have_content(@contract.hiwi.name)
      expect(@page_section).to have_content(@contract.name)
    end

    it 'does not show the current month to be missing' do
      expect(@page_section.all('.col-md-3').first).not_to have_content(I18n.l(@end_date, format: :short_month_year))
    end

    it 'does not show dismissed entries' do
      FactoryGirl.create(:dismissed_missing_timesheet, contract: @contract, user: @representative, month: @start_date.at_beginning_of_month)
      expect(DismissedMissingTimesheet.dates_for(@representative,@contract).size).to eq(1)

      visit dashboard_path
      @page_section = page.find('#missing_timesheets')

      expect(@page_section).to have_content(I18n.t('no_entries_yet', target: I18n.t('activerecord.models.time_sheet.other')))
    end

    it 'has a button to dismiss entries' do
      button = @page_section.find('.btn')
      expect(button).not_to be nil

      click_on button.text

      @page_section = page.find('#missing_timesheets')

      expect(DismissedMissingTimesheet.dates_for(@representative,@contract).size).to eq(1)
      expect(page).to have_content(I18n.t('dashboard.index.dismissed'))
      expect(@page_section).to have_content(I18n.t('no_entries_yet', target: I18n.t('activerecord.models.time_sheet.other')))
    end
  end
end