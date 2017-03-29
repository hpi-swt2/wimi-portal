require 'rails_helper'

describe 'timesheets#show' do
  before :each do
    @time_sheet = FactoryGirl.create(:time_sheet)
    @user = @time_sheet.contract.hiwi
    login_as @user
  end

  context 'with include comments preference' do
    it 'always, always includes comments' do
      @user.update({include_comments: 'always'})
      @user.reload

      visit time_sheets_path

      expect(page).to have_link(nil, download_time_sheet_path(@time_sheet, include_comments: 1))
    end

    it 'never, never includes comments' do
      @user.update({include_comments: 'never'})
      @user.reload

      visit time_sheets_path

      expect(page).to have_link(nil, download_time_sheet_path(@time_sheet, include_comments: 0))
    end

    # TODO test modal somehow
    # it 'ask, toggles a modal if the time sheet has comments' do
    #   @user.update({include_comments: 'ask'})
    #   @user.reload

    #   @workday = FactoryGirl.create(:work_day, notes: "Lorem")
    #   @time_sheet.work_days << @workday

    #   expect(@time_sheet.has_comments?).to be true

    #   visit time_sheets_path
    #   expect(page).to have_current_path(time_sheets_path)

    #   click_on("PDF")

    #   expect(page).to have_content(I18n.t("time_sheet.download.has_comments"))
    # end
  end
end