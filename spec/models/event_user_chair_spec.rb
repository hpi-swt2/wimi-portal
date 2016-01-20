require 'rails_helper'

RSpec.describe EventUserChair, type: :model do
  describe 'GET #index' do
    it 'sets defaults for seclevel and type' do
      chair = FactoryGirl.create(:chair)
      trigger = FactoryGirl.create(:user)
      target = FactoryGirl.create(:user)
      @event = EventUserChair.create(trigger_id: trigger.id, target_id: target.id, chair_id: chair.id)
      expect(@event.seclevel).to eq('admin')
    end
  end
end