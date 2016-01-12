require 'rails_helper'

RSpec.describe WorkDaysController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/work_days').to route_to('work_days#index')
    end

    it 'routes to #new' do
      expect(get: '/work_days/new').to route_to('work_days#new')
    end

    it 'routes to #show' do
      expect(get: '/work_days/1').to route_to('work_days#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/work_days/1/edit').to route_to('work_days#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/work_days').to route_to('work_days#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/work_days/1').to route_to('work_days#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/work_days/1').to route_to('work_days#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/work_days/1').to route_to('work_days#destroy', id: '1')
    end
  end
end
