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
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'returns the seclevel of a user' do
    chair = FactoryGirl.create(:chair)
    project = FactoryGirl.create(:project)
    #user
    user = FactoryGirl.create(:user)
    expect(Event.seclevel_of_user(user)).to eq(Event.seclevels[:user])
    #hiwi
    project.users << user
    user = User.find(user.id)
    expect(Event.seclevel_of_user(user)).to eq(Event.seclevels[:hiwi])
    #wimi
    ChairWimi.create(user: user, chair: chair, application: 'accepted')
    expect(Event.seclevel_of_user(user)).to eq(Event.seclevels[:wimi])
    #representative
    ChairWimi.first.update(representative: true)
    user = User.find(user.id)
    expect(Event.seclevel_of_user(user)).to eq(Event.seclevels[:representative])
    #admin
    ChairWimi.first.update(admin: true)
    user = User.find(user.id)
    expect(Event.seclevel_of_user(user)).to eq(Event.seclevels[:admin])
    #superadmin
    user.update(superadmin: true)
    user = User.find(user.id)
    expect(Event.seclevel_of_user(user)).to eq(Event.seclevels[:superadmin])
  end
end
