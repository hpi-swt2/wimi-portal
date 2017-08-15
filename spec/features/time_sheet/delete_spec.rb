require 'rails_helper'

describe 'time_sheets#edit' do
  before :each do
    @hiwi = FactoryGirl.create(:hiwi)
    @wimi = FactoryGirl.create(:wimi).user
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
    login_as @hiwi
  end

  context 'with a new (not handed in) time sheet' do
    before :each do
      @time_sheet = FactoryGirl.create(:time_sheet, contract: @contract)
      visit edit_time_sheet_path(@time_sheet)
    end

    it 'has a delete button' do
      expect(page).to have_delete_link(@time_sheet)
    end

    it 'is possible to delete an empty time sheet' do
      expect(@time_sheet.work_days.count).to eq(0)
      expect { find('#delete').click }.to change { TimeSheet.count }.from(1).to(0)
      # No flash error
      expect(page).to_not have_css('div.alert-danger')
    end

    it 'is possible to delete a time sheet with work days' do
      FactoryGirl.create(:work_day, time_sheet: @time_sheet, date: Date.today.beginning_of_month)
      FactoryGirl.create(:work_day, time_sheet: @time_sheet, date: Date.today.beginning_of_month + 1.day)
      expect(@time_sheet.work_days.count).to eq(2)
      expect(WorkDay.count).to eq(2)

      expect { find('#delete').click }.to change { TimeSheet.count }.from(1).to(0)
      expect(WorkDay.count).to eq(0)
      # No flash error
      expect(page).to_not have_css('div.alert-danger')
    end
  end

  context 'with a handed in time sheet' do
    before :each do
      @time_sheet_handed_in = FactoryGirl.create(:time_sheet, contract: @contract, handed_in: true)
      visit edit_time_sheet_path(@time_sheet_handed_in)
    end

    it 'does not have a delete button' do
      expect(page).to_not have_delete_link(@time_sheet_handed_in)
    end
  end
end