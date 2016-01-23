require 'rails_helper'

RSpec.describe 'WorkDays', type: :request do
  describe 'GET /work_days' do
    it 'should redirect to the work_days_path with the current date' do
      get work_days_path
      expect(response).to have_http_status(302)
    end
  end
end
