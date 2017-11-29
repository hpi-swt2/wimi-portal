require 'rails_helper'

describe 'project#show' do
  context 'as a wimi' do
    before(:each) do
      @wimi = FactoryGirl.create(:wimi).user
      @chair = @wimi.chair
      @project = FactoryGirl.create(:project, chair: @chair)
      @hiwi = FactoryGirl.create(:hiwi, chair: @chair, responsible: @wimi)
      @timesheet = FactoryGirl.create(:time_sheet, contract: @hiwi.contracts.first)
      @wimi.projects << @project
      @hiwi.projects << @project
      login_as @wimi
      visit project_path(@project)
    end
    
    it 'shows current time sheet button for a hiwi' do
      expect(page).to have_selector(:linkhref, time_sheet_path(@timesheet))
    end
    
    it 'shows contract button for a hiwi' do
      expect(page).to have_selector(:linkhref, contract_path(@hiwi.contracts.first))
    end
  end
end
