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

FactoryGirl.define do
  factory :trip_datespan do
    start_date Date.today
    end_date Date.today + 10
    days_abroad 5
    trip nil
  end

end
