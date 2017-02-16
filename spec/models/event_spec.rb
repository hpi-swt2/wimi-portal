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

  context 'Events are created on' do
    context 'time_sheet' do
      before :each do
        @sheet = FactoryGirl.create(:time_sheet)
        @user = @sheet.contract.hiwi
      end

      it 'hand in' do
        @sheet.hand_in(@user)

        expect(Event.all.count).to eq(1)
        expect(Event.first.type).to eq('time_sheet_hand_in')
      end

      it 'accept' do
        @sheet.accept_as(@sheet.contract.responsible)

        expect(Event.all.count).to eq(1)
        expect(Event.first.type).to eq('time_sheet_accept')
      end

      it 'decline' do
        @sheet.reject_as(@sheet.contract.responsible)

        expect(Event.all.count).to eq(1)
        expect(Event.first.type).to eq('time_sheet_decline')
      end
    end
  end
end

RSpec.describe ChairsController, type: :controller do
  before :each do
    @chair = FactoryGirl.create(:chair)
    @representative = @chair.representative.user
    @user = FactoryGirl.create(:user)
    login_as @representative
  end


  context 'Events are created on' do
    it 'adding a user' do
      post :add_user, id: @chair.id, add_user_to_chair: { id: @user.id }

      expect(flash[:success]).to eq(I18n.t('chair.user.successfully_added', name: @user.name))
      expect(Event.all.count).to eq(1)
      expect(Event.first.type).to eq('chair_join')
    end

    it 'removing a user' do
      delete :remove_user, id: @chair.id, request: @user.id

      expect(Event.all.count).to eq(1)
      expect(Event.first.type).to eq('chair_leave')
    end
  end
end