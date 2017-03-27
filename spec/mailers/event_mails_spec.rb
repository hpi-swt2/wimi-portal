require "rails_helper"

RSpec.describe Event, type: :model do
  context 'users want mail' do
    before :each do
      @user = FactoryGirl.create(:user)
      @user_ability = Ability.new(@user)
      @user2 = FactoryGirl.create(:user)
      @user2_ability = Ability.new(@user2)
      @event = FactoryGirl.create(:event, user: @user, target_user: @user2)
      expect(@user_ability.can? :receive_email, @event).to be false
      expect(@user2_ability.can? :receive_email, @event).to be true
      @user2.update(event_settings: [@event.type_id])
    end

    it 'doesn\'t send an email to the person that initiated' do
      expect(@event.users_want_mail).to_not include(@user)
    end

    it 'contains only users that can? :receive_email for the event' do
      expect(@event.users_want_mail).to include(@user2)
    end

    it 'contains only users that include the event type in the email settings' do
      expect(@event.users_want_mail).to include(@user2)
      @user2.update(event_settings: [])
      expect(@event.users_want_mail).to eq([])
    end
  end

  context 'mails are sent' do
    before :each do
      @user = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @event = FactoryGirl.build(:event, user: @user, target_user: @user2)
      @user2.update(event_settings: [@event.type_id])
    end

    it 'on event creation' do
      expect(@event.users_want_mail).to include(@user2)
      expect(ApplicationMailer).to receive(:notification).with(@event, @user2)
      @event.save!
    end
  end
end
