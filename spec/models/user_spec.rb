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
#  residence                 :string
#  street                    :string
#  personnel_number          :integer          default(0)
#  remaining_leave           :integer          default(28)
#  remaining_leave_last_year :integer          default(0)
#  identity_url              :string
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
  	expect(FactoryGirl.create(:user)).to be_valid
  end

  it "returns the full name of the user" do
    user = FactoryGirl.create(:user)
    expect(user.name).to eq("Joe Doe")
  end

  it "splits fullname into first and last name" do
  	user = FactoryGirl.create(:user, first_name: nil, last_name: nil, name: 'Jane Smith')
  	expect(user.first_name).to eq('Jane')
  	expect(user.last_name).to eq('Smith')
  end

  it 'checks functionality of is_wimi? function' do
    user = FactoryGirl.create(:user)
    chair = FactoryGirl.create(:chair)
    expect(user.is_wimi?).to eq(false)
    chairwimi = ChairWimi.create(:user => user, :chair => chair, :application => 'accepted')
    expect(user.is_wimi?).to eq(true)
  end

  it 'checks functionality of is_hiwi? function' do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project)
    expect(User.find(user.id).is_hiwi?).to eq(false)
    project.users << user
    expect(User.find(user.id).is_hiwi?).to eq(true)
  end
end
