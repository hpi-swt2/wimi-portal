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

  it "requires user, object and target_user to be valid" do
    user = FactoryGirl.create(:user)
    expect(Event.new).to_not be_valid
    event = Event.new(user: user, object: user, target_user: user)
    expect(event).to be_valid
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

  # Only ints representing event types are saved in the db.
  # If the order / count is changed, this needs to be reflected in the
  # existing database with a migration. Beware.
  it 'has the original order of type Enum' do
    original_enum_order = {
      "time_sheet_hand_in"=>0,
      "time_sheet_accept"=>1,
      "time_sheet_decline"=>2,
      "project_create"=>3,
      "project_join"=>4,
      "project_leave"=>5,
      "chair_join"=>6,
      "chair_leave"=>7,
      "chair_add_admin"=>8,
      "contract_create"=>9,
      "contract_extend"=>10,
      "time_sheet_closed"=>11,
    }
    expect(Event.types).to eq(original_enum_order)
  end
end
