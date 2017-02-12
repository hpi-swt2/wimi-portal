require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build_stubbed(:event)).to be_valid
  end

  it 'can access the I18n keys' do
    event = FactoryGirl.create(:event, type: 'test')
    expect(event.message).to include('test')
    expect(event.message).to include(event.user.name)
  end

  it 'prints the unique message for each type' do
    Event.types.each do |type, value| 
      event = FactoryGirl.create(:event, type: type)
      expect(event.message).to eq(I18n.t("event.#{event.type}", 
                                    user: event.user.name, 
                                    target_object: event.object.name, 
                                    target_user: event.target_user.name))
    end
  end
end