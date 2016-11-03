require 'rails_helper'

describe 'time_sheets#edit' do
  before :each do
    @hiwi = FactoryGirl.create(:hiwi)
    @wimi = FactoryGirl.create(:wimi).user
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
    @time_sheet_new = FactoryGirl.create(:time_sheet, contract: @contract)
    login_as @hiwi
  end

  it 'allows adding a work_day' do
    visit edit_time_sheet_path(@time_sheet_new)
    start_time = '10:00'
    break_duration = '60'
    end_time = '14:00'
    note = 'A note'

    fill_in "time_sheet_work_days_attributes_0_start_time", with: start_time
    fill_in "time_sheet_work_days_attributes_0_break", with: break_duration
    fill_in "time_sheet_work_days_attributes_0_end_time", with: end_time
    fill_in "time_sheet_work_days_attributes_0_notes", with: note

    find('#hiddensubmit').click
    # No flash error
    expect(page).to_not have_css('div.alert-danger')
    expect(page).to have_content(start_time)
    expect(page).to have_content(break_duration)
    expect(page).to have_content(end_time)
    expect(page).to have_content(note)
    # redirect to timesheet#show
    expect(page).to have_current_path(time_sheet_path(@time_sheet_new))
  end

  context 'when deleting a work day' do
    before :each do
      @work_day = FactoryGirl.create(:work_day, time_sheet: @time_sheet_new, date: Date.today.beginning_of_month)
    end

    it 'is possible to clear a work day by inputting zeros' do
      visit edit_time_sheet_path(@time_sheet_new)
      
      fill_in "time_sheet_work_days_attributes_0_start_time", with: '0'
      fill_in "time_sheet_work_days_attributes_0_break", with: '0'
      fill_in "time_sheet_work_days_attributes_0_end_time", with: '0'
      fill_in "time_sheet_work_days_attributes_0_notes", with: ''

      find('#hiddensubmit').click
      # No flash error
      expect(page).to_not have_css('div.alert-danger')
      # On successful update the overview is rendered
      # and doesn't list the removed work day
      expect(page).to_not have_content(I18n.l(@work_day.date, format: :day_month))
      expect(page).to_not have_content(I18n.l(@work_day.date, format: :weekday_short))
    end

    it 'is possible to clear a work day by clearing all inputs' do
      visit edit_time_sheet_path(@time_sheet_new)
      
      fill_in "time_sheet_work_days_attributes_0_start_time", with: ''
      fill_in "time_sheet_work_days_attributes_0_break", with: ''
      fill_in "time_sheet_work_days_attributes_0_end_time", with: ''
      fill_in "time_sheet_work_days_attributes_0_notes", with: ''

      find('#hiddensubmit').click
      # No flash error
      expect(page).to_not have_css('div.alert-danger')
      expect(page).to have_current_path(time_sheet_path(@time_sheet_new))
      expect(page).to_not have_content(@work_day.notes)
    end
  end

  context 'when editing a work day' do
    before :each do
      @work_day = FactoryGirl.create(:work_day, time_sheet: @time_sheet_new, date: Date.today.beginning_of_month)
    end

    it 'is possible to save the inputs' do
      visit edit_time_sheet_path(@time_sheet_new)
      old_note = @work_day.notes
      start_time = '18:00'
      break_duration = '60'
      end_time = '20:00'
      note = 'Another note'

      fill_in "time_sheet_work_days_attributes_0_start_time", with: start_time
      fill_in "time_sheet_work_days_attributes_0_break", with: break_duration
      fill_in "time_sheet_work_days_attributes_0_end_time", with: end_time
      fill_in "time_sheet_work_days_attributes_0_notes", with: note

      find('#hiddensubmit').click
      # No flash error
      expect(page).to_not have_css('div.alert-danger')
      expect(page).to have_content(start_time)
      expect(page).to have_content(break_duration)
      expect(page).to have_content(end_time)
      expect(page).to have_content(note)
      expect(page).to_not have_content(old_note)
      # redirect to timesheet#show
      expect(page).to have_current_path(time_sheet_path(@time_sheet_new))
    end
  end

  context 'when inputting erroneous data' do
    it 'is redirects to the timesheet#edit again' do
      visit edit_time_sheet_path(@time_sheet_new)

      fill_in "time_sheet_work_days_attributes_0_start_time", with: '18:00'
      fill_in "time_sheet_work_days_attributes_0_end_time", with: '10:00'
      fill_in "time_sheet_work_days_attributes_0_notes", with: 'FAILURE'

      find('#hiddensubmit').click
      # flash error
      expect(page).to have_css('div.alert-danger')
      # redirect to timesheet#update
      expect(page).to have_current_path(time_sheet_path(@time_sheet_new))
    end
  end

end