# == Schema Information
#
# Table name: trips
#
#  id          :integer          not null, primary key
#  destination :string
#  reason      :text
#  annotation  :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :integer          default(0)
#  signature   :boolean
#

require 'rails_helper'

RSpec.describe Trip, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:trip)).to be_valid
  end

  it 'returns user name' do
    trip = FactoryGirl.create(:trip)
    expect(trip.name).to eq('Joe Doe')
  end
end
