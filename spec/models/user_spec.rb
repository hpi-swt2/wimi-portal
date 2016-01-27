# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string           default(""), not null
#  first_name                :string
#  last_name                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  identity_url              :string
#  language                  :string           default("en"), not null
#  street                    :string
#  personnel_number          :integer          default(0)
#  remaining_leave           :integer          default(28)
#  remaining_leave_last_year :integer          default(0)
#  superadmin                :boolean          default(FALSE)
#  username                  :string
#  encrypted_password        :string           default(""), not null
#  city                      :string
#  zip_code                  :string
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:user)).to be_valid
  end

  it 'returns the full name of the user' do
    user = FactoryGirl.create(:user)
    expect(user.name).to eq('Joe Doe')
  end

  it 'splits fullname into first and last name' do
    user = FactoryGirl.create(:user, first_name: nil, last_name: nil, name: 'Jane Smith')
    expect(user.first_name).to eq('Jane')
    expect(user.last_name).to eq('Smith')
  end

  it 'checks functionality of is_wimi? function' do
    user = FactoryGirl.create(:user)
    chair = FactoryGirl.create(:chair)
    expect(user.is_wimi?).to eq(false)
    chairwimi = ChairWimi.create(user: user, chair: chair, application: 'accepted')
    expect(user.is_wimi?).to eq(true)
  end

  it 'checks functionality of is_hiwi? function' do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project)
    expect(User.find(user.id).is_hiwi?).to eq(false)
    project.users << user
    expect(User.find(user.id).is_hiwi?).to eq(true)
  end

  it 'returns trips in the right order' do
    user = FactoryGirl.create(:user)
    trip_a = FactoryGirl.create(:trip, user: user)
    datespan_a = FactoryGirl.create(:trip_datespan, trip: trip_a, start_date: Date.today + 5, end_date: Date.today + 6, days_abroad: 0)
    trip_b = FactoryGirl.create(:trip, user: user)
    datespan_b = FactoryGirl.create(:trip_datespan, trip: trip_b, start_date: Date.today + 10, end_date: Date.today + 16, days_abroad: 0)
    expect(user.get_desc_sorted_datespans[0]).to eq(datespan_b)
  end

  it 'validates the zip code correctly' do
    expect(FactoryGirl.build(:user, zip_code: '')).to be_valid
    expect(FactoryGirl.build(:user, zip_code: '01234')).to be_valid
    expect(FactoryGirl.build(:user, zip_code: 'abc')).to_not be_valid
    expect(FactoryGirl.build(:user, zip_code: 'abcde')).to_not be_valid
  end
end
