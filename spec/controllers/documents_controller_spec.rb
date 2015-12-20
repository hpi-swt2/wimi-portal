require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do

  before(:each) do
    login_with create ( :user)
  end

  describe "GET generate_pdf" do
    it 'should raise an argument error for missing parameters' do
      params = {}
      expect {get :generate_pdf, params}.to raise_error(ArgumentError)
    end

    it 'should raise an not implemented error for a missing template' do
      trip = FactoryGirl.create(:trip)
      params = {:doc_type => 'ThatsNOTaDocument', :doc_id => trip.id}
      expect {get :generate_pdf, params}.to raise_error(NotImplementedError)
    end

    it 'should generate a PDF file for a travel expense reports' do
      report = FactoryGirl.create(:travel_expense_report)
      params = {:doc_type => 'Reisekostenabrechnung', :doc_id => report.id}
      get :generate_pdf, params
      expect(response.headers["Content-Type"]).to eq("application/pdf")
      expect(response.headers["Content-Disposition"]).to eq("attachment; filename=\"Reisekostenabrechnung.pdf\"")
    end

    it 'should generate a PDF file for a business trip' do
      trip = FactoryGirl.create(:trip)
      params = {:doc_type => 'Dienstreiseantrag', :doc_id => trip.id}
      get :generate_pdf, params
      expect(response.headers["Content-Type"]).to eq("application/pdf")
      expect(response.headers["Content-Disposition"]).to eq("attachment; filename=\"Dienstreiseantrag.pdf\"")
    end
  end
end
