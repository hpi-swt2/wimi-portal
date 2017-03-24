# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  target_user_id :integer
#  object_id      :integer
#  object_type    :string
#  created_at     :datetime
#  type           :integer
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build_stubbed(:event)).to be_valid
  end

  it "can be created using 'add' constructor" do
    user = FactoryGirl.create(:user)
    Event.types.each do |type, value|
      expect {
        Event.add(type, user, user, user)
      }.to change { Event.count }.by(1)
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
      expect { @user.destroy }.to change { Event.count }.from(1).to(0)
    end

    it 'the target user is destroyed' do
      expect { @target_user.destroy }.to change { Event.count }.from(1).to(0)
    end

    it 'the associated object is destroyed' do
      expect { @chair.destroy }.to change { Event.count }.from(1).to(0)
    end
  end
end
