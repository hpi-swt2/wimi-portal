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