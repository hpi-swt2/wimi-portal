require 'rails_helper'

RSpec.describe Trip, type: :model do
  before :each do
    @trip = FactoryGirl.build(:trip)
  end

  it 'has a valid factory' do
    expect(@trip).to be_valid
  end

  it 'returns user name' do
    expect(@trip.name).to eq('Joe Doe')
  end

  context 'with valid input' do
    it 'creates a valid report' do
      expect(@trip.valid?).to be true
    end
  end

  context 'with invalid input' do
    it 'rejects dates in wrong order' do
      @trip.date_end = Date.today - 10
      expect(@trip.valid?).to be false
    end

    it 'rejects days abroad larger than actual timespan' do
      @trip.days_abroad = 100
      expect(@trip.valid?).to be false
    end

    it 'rejects negative values for days abroad' do
      @trip.days_abroad = -20
      expect(@trip.valid?).to be false
    end
  end
end
