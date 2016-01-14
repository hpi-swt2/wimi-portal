require 'rails_helper'

RSpec.describe EventUserChair, type: :model do
  describe 'GET #index' do
    it 'sets defaults for seclevel and type' do
      @event = EventUserChair.create(trigger_id: 1, target_id: 2, chair_id: 1)
      expect(@event.seclevel).to eq('admin')
    end
  end
end