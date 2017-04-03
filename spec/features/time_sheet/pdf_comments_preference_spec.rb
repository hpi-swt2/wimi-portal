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

    it "'ask' setting toggles a modal if the time sheet has comments" do
      @user.update({include_comments: 'ask'})
      @workday = FactoryGirl.create(:work_day, notes: "Some notes")
      @time_sheet.work_days << @workday
      @time_sheet.save!
      expect(@time_sheet.has_comments?).to be true
      visit time_sheets_path
      expect(page).to have_current_path(time_sheets_path)

      # Link does not include 'include_comments' params 
      expect(page).to have_link(nil, download_time_sheet_path(@time_sheet))

      click_on("PDF")
      # Clicking the link did not immediately download a PDF
      expect(response_headers["Content-Type"]).to_not include("pdf")
    end
  end
end