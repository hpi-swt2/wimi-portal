require 'rails_helper'

describe 'dashboard#index' do
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
    end

    it 'shows missing timesheets for past months' do
      expect(page.find('#missing_timesheets').all('.col-md-4').first).to have_content(I18n.l(@start_date, format: :short_month_year))
      expect(page.find('#missing_timesheets')).to have_content(@contract.hiwi.name)
      expect(page.find('#missing_timesheets')).to have_content(@contract.name)
    end

    it 'does not show the current month to be missing' do
      expect(page.find('#missing_timesheets').all('.col-md-4').first).not_to have_content(I18n.l(@end_date, format: :short_month_year))
    end
  end

end