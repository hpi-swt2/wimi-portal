# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string
#  last_sign_in_ip           :string
#  first                     :string
#  last_name                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  remaining_leave           :integer          default(28)
#  remaining_leave_last_year :integer          default(0)
#  residence                 :string
#  street                    :string
#  division                  :string
#  personnel_number          :integer          default(1)
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
  	expect(FactoryGirl.create(:user)).to be_valid
  end

  it "returns the full name of the user" do
    @user = FactoryGirl.create(:user)
    expect(@user.name).to eq('John Doe')
  end

  it "splits fullname into first and last name" do
  	@user = FactoryGirl.create(:user, first: nil, last_name: nil, name: 'Jane Smith')
  	expect(@user.first).to eq('Jane')
  	expect(@user.last_name).to eq('Smith')
  end
end
