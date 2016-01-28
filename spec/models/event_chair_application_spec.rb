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

RSpec.describe EventChairApplication, type: :model do
  describe 'GET #index' do
    it 'sets defaults for seclevel and type' do
      chair = FactoryGirl.build_stubbed(:chair)
      trigger = FactoryGirl.build_stubbed(:user)
      event = EventChairApplication.create(trigger_id: trigger.id, chair_id: chair.id)

      expect(event.seclevel).to eq('admin')
      expect(event.type).to eq('EventChairApplication')
    end
  end
end
