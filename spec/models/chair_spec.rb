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
  it "has a valid factory" do
    expect(FactoryGirl.create(:chair)).to be_valid
  end

  it "returns all hiwis in an unique array" do
    chair = FactoryGirl.create(:chair)
    project1 = FactoryGirl.create(:project)
    project2 = FactoryGirl.create(:project)
    user1 = FactoryGirl.create(:user, first_name: "A")
    user2 = FactoryGirl.create(:user, first_name: "A")
    user3 = FactoryGirl.create(:user, first_name: "A")

    project1.users << user1
    project1.users << user2
    project2.users << user2
    project2.users << user3
    chair.projects << project1
    chair.projects << project2

    expect(chair.hiwis).to eq [user1, user2, user3]
  end

  it "returns all wimis in an unique array" do
    chair = FactoryGirl.create(:chair)
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    user3 = FactoryGirl.create(:user)
    chair_wimi1 = FactoryGirl.create(:chair_wimi, application: 'accepted', user: user1, chair: chair)
    chair_wimi2 = FactoryGirl.create(:chair_wimi, application: 'accepted', user: user2, chair: chair)
    chair_wimi3 = FactoryGirl.create(:chair_wimi, application: 'accepted', user: user3, chair: chair)

    expect(chair.wimis) == [user1, user2, user3]
  end
end
