require 'rails_helper'

RSpec.describe EventChairApplication, type: :model do
  describe 'GET #index' do
    it 'sets defaults for seclevel and type' do
      chair = FactoryGirl.create(:chair)
      trigger = FactoryGirl.create(:user)
      event = EventChairApplication.create(trigger_id: trigger.id, chair_id: chair.id)
      expect(event.seclevel).to eq('admin')
    end
  end
end
