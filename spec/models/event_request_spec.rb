require 'rails_helper'

RSpec.describe EventRequest, type: :model do
  describe 'GET #index' do
    it 'sets defaults for seclevel and type' do
      @event = EventRequest.create(trigger_id: 1, chair_id: 1)
      expect(@event.seclevel).to eq('representative')
    end
  end
end
