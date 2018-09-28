require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_with @user
  end

  describe 'GET generate_pdf' do
    it 'should raise an argument error for missing parameters', :slow => true do
      params = {}
      expect {get :generate_pdf, params}.to raise_error(ArgumentError)
    end

    it 'should raise an not implemented error for a missing template', :slow => true do
      time_sheet = FactoryGirl.create(:time_sheet)
      params = {doc_type: 'ThatsNOTaDocument', doc_id: time_sheet.id}
      expect {get :generate_pdf, params}.to raise_error(NotImplementedError)
    end

    it 'should generate a PDF file for a time sheet', :slow => true do
      chair = FactoryGirl.create(:chair)
      project = FactoryGirl.create(:project, chair: chair)
      time_sheet = FactoryGirl.create(:time_sheet, user: @user, chair: chair)
      FactoryGirl.create(:work_day, project: project)
      params = {doc_type: 'Timesheet', doc_id: time_sheet.id}
      get :generate_pdf, params
      expect(response.headers['Content-Type']).to eq('application/pdf')
      expected_content_disposition = "attachment; filename=\"#{time_sheet.attachment_name}.pdf\""
      expect(response.headers['Content-Disposition']).to eq(expected_content_disposition)
    end
  end
end
