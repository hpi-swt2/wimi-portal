require 'rails_helper'

RSpec.describe TimeSheetsController, type: :routing do
  describe 'routing' do
    it 'routes to #edit' do
      expect(get: '/time_sheets/1/edit').to route_to('time_sheets#edit', id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/time_sheets/1').to route_to('time_sheets#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/time_sheets/1').to route_to('time_sheets#update', id: '1')
    end
  end
end
