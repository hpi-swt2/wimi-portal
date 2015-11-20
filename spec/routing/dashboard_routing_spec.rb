require 'rails_helper'

RSpec.describe DashboardController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/').to route_to('dashboard#index')
    end

    it 'routes to #index after login' do
      expect(current_path).to eq(dashboard)
    end


  end
end
