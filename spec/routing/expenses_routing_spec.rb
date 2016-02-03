require 'rails_helper'

RSpec.describe ExpensesController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/trips/1/expenses/new').to route_to('expenses#new', trip_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/trips/1/expenses/1/edit').to route_to('expenses#edit', id: '1', trip_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/trips/1/expenses').to route_to('expenses#create', trip_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/trips/1/expenses/1').to route_to('expenses#update', id: '1', trip_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/trips/1/expenses/1').to route_to('expenses#update', id: '1', trip_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/trips/1/expenses/1').to route_to('expenses#destroy', id: '1', trip_id: '1')
    end
  end
end
