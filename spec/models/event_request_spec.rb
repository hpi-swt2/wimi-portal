require 'rails_helper'

RSpec.describe EventRequest, type: :model do
  describe 'GET #index' do
    it 'sets defaults for seclevel and type' do
      chair = FactoryGirl.create(:chair)
      trigger = FactoryGirl.create(:user)
      event = EventRequest.create(trigger_id: trigger.id, chair_id: chair.id)
      expect(event.seclevel).to eq('representative')
    end
  end
end
