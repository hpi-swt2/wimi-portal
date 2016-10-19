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
      trip = FactoryGirl.create(:trip)
      params = {doc_type: 'ThatsNOTaDocument', doc_id: trip.id}
      expect {get :generate_pdf, params}.to raise_error(NotImplementedError)
    end

    it 'should generate a PDF file for a travel expense report application', :slow => true do
      report = FactoryGirl.create(:expense)
      params = {doc_type: 'Expense_request', doc_id: report.id}
      get :generate_pdf, params
      expect(response.headers['Content-Type']).to eq('application/pdf')
      expect(response.headers['Content-Disposition']).to eq("attachment; filename=\"Expense_request.pdf\"")
    end

    it 'should generate a PDF file for a business trip application', :slow => true do
      trip = FactoryGirl.create(:trip)
      params = {doc_type: 'Trip_request', doc_id: trip.id}
      get :generate_pdf, params
      expect(response.headers['Content-Type']).to eq('application/pdf')
      expect(response.headers['Content-Disposition']).to eq("attachment; filename=\"Trip_request.pdf\"")
    end

    it 'should generate a PDF file for a holiday application', :slow => true do
      holiday = FactoryGirl.create(:holiday, user: @user)
      params = {doc_type: 'Holiday_request', doc_id: holiday.id}
      get :generate_pdf, params
      expect(response.headers['Content-Type']).to eq('application/pdf')
      expect(response.headers['Content-Disposition']).to eq("attachment; filename=\"Holiday_request.pdf\"")
    end

    it 'should generate a PDF file for a time sheet', :slow => true do
      chair = FactoryGirl.create(:chair)
      project = FactoryGirl.create(:project, chair: chair)
      time_sheet = FactoryGirl.create(:time_sheet, user: @user, chair: chair)
      FactoryGirl.create(:work_day, project: project)
      params = {doc_type: 'Timesheet', doc_id: time_sheet.id}
      get :generate_pdf, params
      expect(response.headers['Content-Type']).to eq('application/pdf')
      expect(response.headers['Content-Disposition']).to eq("attachment; filename=\"Timesheet.pdf\"")
    end
  end
end
