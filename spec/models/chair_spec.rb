# == Schema Information
#
# Table name: chairs
#
#  id           :integer          not null, primary key
#  name         :string
#  abbreviation :string
#  description  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Chair, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build_stubbed(:chair)).to be_valid
  end

  it 'returns all hiwis in an unique array' do
    chair = FactoryBot.create(:chair)
    project1 = FactoryBot.create(:project)
    project2 = FactoryBot.create(:project)
    user1 = FactoryBot.build_stubbed(:user, first_name: 'A')
    user2 = FactoryBot.build_stubbed(:user, first_name: 'A')
    user3 = FactoryBot.build_stubbed(:user, first_name: 'A')

    project1.users << user1
    project1.users << user2
    project2.users << user2
    project2.users << user3
    chair.projects << project1
    chair.projects << project2

    expect(chair.hiwis).to eq [user1, user2, user3]
  end

  it 'returns all wimis in an unique array' do
    chair = FactoryBot.build_stubbed(:chair)
    user1 = FactoryBot.build_stubbed(:user)
    user2 = FactoryBot.build_stubbed(:user)
    user3 = FactoryBot.build_stubbed(:user)
    chair_wimi1 = FactoryBot.build_stubbed(:wimi, application: 'accepted', user: user1, chair: chair)
    chair_wimi2 = FactoryBot.build_stubbed(:wimi, application: 'accepted', user: user2, chair: chair)
    chair_wimi3 = FactoryBot.build_stubbed(:wimi, application: 'accepted', user: user3, chair: chair)

    expect(chair.wimis) == [user1, user2, user3]
  end
end
