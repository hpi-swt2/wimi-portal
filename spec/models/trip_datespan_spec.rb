# == Schema Information
#
# Table name: trip_datespans
#
#  id          :integer          not null, primary key
#  start_date  :date
#  end_date    :date
#  days_abroad :integer
#  trip_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe TripDatespan, type: :model do
  before :each do
    @datespan = FactoryGirl.create(:trip_datespan)
  end

  context 'with valid input' do
    it 'creates a valid report' do
      expect(@datespan.valid?).to be true
    end
  end

  context 'with invalid input' do
    it 'rejects dates in wrong order' do
      @datespan.end_date = Date.today - 10
      expect(@datespan.valid?).to be false
    end

    it 'rejects days abroad larger than actual timespan' do
      @datespan.days_abroad = 100
      expect(@datespan.valid?).to be false
    end

    it 'rejects negative values for days abroad' do
      @datespan.days_abroad = -20
      expect(@datespan.valid?).to be false
    end
  end
end
