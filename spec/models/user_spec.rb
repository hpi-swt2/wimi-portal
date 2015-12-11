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
#  remaining_leave_this_year :integer          default(28)
#  remaining_leave_next_year :integer          default(28)
#  residence                 :string
#  street                    :string
#  division_id               :integer          default(0)
#  personnel_number          :integer          default(0)
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
end
