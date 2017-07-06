require 'rails_helper'

RSpec.describe 'dashboard/index' do
  before :each do
    # create hiwi, contract
    @chair = FactoryGirl.create(:chair)
    @start_date = Date.today << 1
    @end_date = Date.today
    @wimi = FactoryGirl.create(:wimi, chair: @chair).user
    @contract = FactoryGirl.create(:contract, chair: @chair, start_date: @start_date, end_date: @end_date, responsible: @wimi)
  end

  describe 'A representatives dashboard' do
    before :each do
      # create representative
      @representative = FactoryGirl.create(:representative, chair: @chair).user
      login_as @representative
    end

    context "with no missing timesheets" do
      before :each do
        @timesheet1 = FactoryGirl.create(:time_sheet_accepted, contract: @contract, month: @start_date.month, year: @start_date.year)
        @timesheet1 = FactoryGirl.create(:time_sheet_accepted, contract: @contract, month: @end_date.month, year: @end_date.year)
      end

      it 'shows the no entries yet message' do
        visit dashboard_path
        expect(page.find('#missing_timesheets_admin')).to have_content(I18n.t('no_entries_yet', target: I18n.t('activerecord.models.time_sheet.other')))
      end
    end

    context 'with missing timesheets' do
      before :each do
        visit dashboard_path
        @page_section = page.find('#missing_timesheets_admin')
      end

      it 'shows missing timesheets for past months' do
        expect(@page_section).to have_content(I18n.l(@start_date, format: :short_month_year))
        expect(@page_section).to have_content(@contract.responsible.name)
        expect(@page_section).to have_content(@contract.name)
      end

      it 'does not show the wimi view' do
        expect(page).to_not have_selector(:css, "#missing_timesheets_wimi")
      end
    end
  end

  describe 'a wimis dashboard' do
    before :each do
      login_as @wimi
    end

    context 'with no missing timesheets' do
      before :each do
        @timesheet1 = FactoryGirl.create(:time_sheet_accepted, contract: @contract, month: @start_date.month, year: @start_date.year)
        @timesheet1 = FactoryGirl.create(:time_sheet_accepted, contract: @contract, month: @end_date.month, year: @end_date.year)
      end
      
      it 'displays the no entries yet message' do
        visit dashboard_path
        expect(page.find('#missing_timesheets_wimi')).to have_content(I18n.t('no_entries_yet', target: I18n.t('activerecord.models.time_sheet.other')))
      end
    end

    context 'with missing timesheets' do
      before :each do
        @contract_not_responsible = FactoryGirl.create(:contract, start_date: @start_date, end_date: @end_date >> 1, chair: @chair)
        visit dashboard_path
        @page_section = page.find('#missing_timesheets_wimi')
      end

      it 'displays timesheets the wimi is responsible for' do
        expect(@page_section).to have_content(I18n.l(@start_date, format: :short_month_year))
        expect(@page_section).to_not have_content(@contract.responsible.name)
        expect(@page_section).to have_content(@contract.name)
      end

      it 'does not display timesheets the wimi is not responsible for' do
        expect(@page_section).to_not have_content(@contract_not_responsible.name)
      end
    
      it 'does not show the admin/representative view' do
        expect(page).to_not have_selector(:css, '#missing_timesheets_admin')
      end

      it 'displays working time of created but not handed-in timesheets' do
        @timesheet1 = FactoryGirl.create(:time_sheet, contract: @contract, month: @start_date.month, year: @start_date.year)
        @wd = FactoryGirl.create(:work_day, time_sheet: @timesheet1)
        visit dashboard_path
        expect(page).to have_content(@timesheet1.sum_minutes_formatted)
      end
    end
  end
end