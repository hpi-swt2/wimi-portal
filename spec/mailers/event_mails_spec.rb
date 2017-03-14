require "rails_helper"

RSpec.describe Event, type: :model do
  context 'users want mail' do
    before :each do
      @user = FactoryGirl.create(:user)
      @user_ability = Ability.new(@user)
      @user2 = FactoryGirl.create(:user)
      @user2_ability = Ability.new(@user2)
      @event = FactoryGirl.create(:event, user: @user, target_user: @user)
      expect(@user_ability.can? :show,@event).to be true
      expect(@user2_ability.can? :show, @event).to be false
      @user.update_event_settings([@event.type])
    end

    it 'contains only users that can? :show the event' do
      expect(@event.users_want_mail).to include(@user)
    end

    it 'contains only users that include the event type in the email settings' do
      expect(@event.users_want_mail).to include(@user)
      @user.update_event_settings([])
      expect(@event.users_want_mail).to eq([])
    end
  end

  context 'mails are sent' do
    before :each do
      @user = FactoryGirl.create(:user)
      @event = FactoryGirl.create(:event, user: @user, target_user: @user)
      @user.update_event_settings([@event.type])
    end

    it 'on event creation' do
      expect(MailNotifier).to receive(:notification).with(@event,@user)
      @event.run_callbacks(:commit)
    end
  end
end
