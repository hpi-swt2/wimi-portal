require 'rails_helper'

describe 'time_sheet#show' do
  before :each do
    @user = FactoryGirl.create(:user)
    today = Date.today
    @start_date = (today - 1.month).beginning_of_month
    @end_date = (today + 1.month).end_of_month
    @contract = FactoryGirl.create(:contract, hiwi: @user, start_date: @start_date, end_date: @end_date)
    @time_sheet = FactoryGirl.create(:time_sheet, contract: @contract, month: today.month)
    login_as @user
  end

  context "previous and next month's time sheets are available" do
    before :each do
      @time_sheet_next = FactoryGirl.create(:time_sheet, contract: @contract, month: @end_date.month, year: @end_date.year)
      @time_sheet_prev = FactoryGirl.create(:time_sheet, contract: @contract, month: @start_date.month, year: @start_date.year)
    end

    it "has a button to navigate to next month's time sheet" do
      visit time_sheet_path(@time_sheet)
      expect(page).to have_content(I18n.t('time_sheets.show.next_month'))
      click_on I18n.t('time_sheets.show.next_month')
      expect(current_path).to eq(time_sheet_path(@time_sheet_next))
    end

    it "has a button to navigate to the previous month's time sheet" do
      visit time_sheet_path(@time_sheet)
      expect(page).to have_content(I18n.t('time_sheets.show.previous_month'))
      click_on I18n.t('time_sheets.show.previous_month')
      expect(current_path).to eq(time_sheet_path(@time_sheet_prev))
    end
  end

  context "only the time sheet for the current month exists" do
    it "has a button to create a sheet for next month if it doesn't exist yet" do
      visit time_sheet_path(@time_sheet)
      click_on I18n.t('time_sheets.show.create_next_month')
      expect(current_path).to eq(new_contract_time_sheet_path(@contract))
    end

    it "has no button to create a sheet for next month if there is no contract for that month" do
      @contract.end_date = @contract.start_date
      @contract.save!
      visit time_sheet_path(@time_sheet)
      expect(page).not_to have_content(I18n.t('time_sheets.show.next_month'))
      expect(page).not_to have_content(I18n.t('time_sheets.show.create_next_month'))
    end
  end

end