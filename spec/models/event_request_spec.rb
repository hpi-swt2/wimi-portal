# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  trigger_id :integer
#  target_id  :integer
#  chair_id   :integer
#  seclevel   :integer
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :string
#

require 'rails_helper'

RSpec.describe EventRequest, type: :model do
  describe 'GET #index' do
    it 'sets defaults for seclevel and type' do
      chair = FactoryGirl.create(:chair)
      trigger = FactoryGirl.create(:user)
      event = EventRequest.create(trigger_id: trigger.id, chair_id: chair.id)

      expect(event.seclevel).to eq('representative')
      expect(event.type).to	eq('EventRequest')
    end
  end
end
