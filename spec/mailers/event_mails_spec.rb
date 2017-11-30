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

  context 'mails are' do
    before :each do
      @user = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @event = FactoryGirl.build(:event, user: @user, target_user: @user2)
      @user2.update(event_settings: [@event.type_id])
    end

    it 'sent on event creation' do
      expect(@event.users_want_mail).to include(@user2)
      expect { @event.save! }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'not sent on creation if the event has mail disabled' do
      # enum mapping is stored in hash, thus first twice
      allow(Event).to receive(:NOMAIL) {[Event.types.first.first]}
      @event.type = Event.types.first.first
      expect(@event).to have_mail_disabled
      expect { @event.save! }.to change(ActionMailer::Base.deliveries, :count).by(0)
    end

    it 'not sent if no user wants mail for it' do
      @user.update(event_settings: [])
      @user2.update(event_settings: [])
      expect(@event).not_to have_mail_disabled
      expect(@event.always_send?).to be false
      expect { @event.save! }.to change(ActionMailer::Base.deliveries, :count).by(0)
    end

    it 'always sent if event type is in Event.ALWAYS_SEND' do
      @user2.update!(event_settings: [])
      allow(Event).to receive(:ALWAYS_SEND) {[Event.types.first.first]}
      @event.type = Event.types.first.first
      expect(@event.always_send?).to be true
      expect { @event.save! }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end
