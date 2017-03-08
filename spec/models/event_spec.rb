require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build_stubbed(:event)).to be_valid
  end

  it 'creates valid messages from I18n keys' do
    event = FactoryGirl.create(:event)
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

  context 'self.add' do
    it 'adds an event' do
      expect(Event.all.count).to eq(0)

      user = FactoryGirl.create(:user)
      Event.add('default', user, user, user)

      expect(Event.all.count).to eq(1)
    end
  end

  context 'cascade deletes when' do
    before :each do
      @user = FactoryGirl.create(:user)
      @target_user = FactoryGirl.create(:user)
      @chair = FactoryGirl.create(:chair)
      event = FactoryGirl.create(:event, user: @user, object: @chair, target_user: @target_user)
    end

    it 'the creating user is destroyed' do
      expect(Event.count).to eq(1)
      @user.destroy
      expect(Event.count).to eq(0)
    end

    it 'the target user is destroyed' do
      expect(Event.count).to eq(1)
      @target_user.destroy
      expect(Event.count).to eq(0)
    end

    it 'the associated object is destroyed' do
      expect(Event.count).to eq(1)
      @chair.destroy
      expect(Event.count).to eq(0)
    end
  end
end

