# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string           default(""), not null
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string
#  last_sign_in_ip           :string
#  first_name                :string
#  last_name                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  identity_url              :string
#  residence                 :string
#  street                    :string
#  division_id               :integer          default(0)
#  personnel_number          :integer          default(0)
#  remaining_leave           :integer          default(28)
#  remaining_leave_last_year :integer          default(0)
#  superadmin                :boolean          default(FALSE)
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
end
