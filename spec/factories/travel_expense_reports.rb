# == Schema Information
#
# Table name: travel_expense_reports
#
#  id               :integer          not null, primary key
#  inland           :boolean
#  country          :string
#  location_from    :string
#  location_via     :string
#  location_to      :string
#  reason           :text
#  date_start       :datetime
#  date_end         :datetime
#  car              :boolean
#  public_transport :boolean
#  vehicle_advance  :boolean
#  hotel            :boolean
#  status           :integer          default(0)
#  general_advance  :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  signature        :boolean
#

FactoryGirl.define do
  factory :travel_expense_report do
    inland true
    country 'Germany'
    location_from 'Potsdam'
    location_via 'London'
    location_to 'NYC'
    reason 'Hana Things'
    date_start 8.days.ago
    date_end DateTime.now
    car true
    public_transport true
    vehicle_advance false
    hotel true
    general_advance 2000
    signature true
    user
    after(:create) do |report|
      report.travel_expense_report_items << FactoryGirl.build(:travel_expense_report_item, travel_expense_report: report)
    end
  end

  factory :travel_expense_report_invalid, class: TravelExpenseReport do
    inland true
    country 'Germany'
    location_from 'Potsdam'
    location_via 'London'
    location_to 'NYC'
    reason 'Hana Things'
    date_start DateTime.now
    date_end 8.days.ago
    car true
    public_transport true
    vehicle_advance false
    hotel true
    general_advance -20
    signature true
    user
    to_create {|i| i.save(validate: false)}
  end

  factory :travel_expense_report_changed, parent: :travel_expense_report do
    location_from 'Berlin'
    general_advance 1337
    car false
    hotel false
    vehicle_advance true
    date_start 5.days.ago
  end

  factory :travel_expense_report_blank_name, parent: :travel_expense_report do
    first_name ''
  end

  factory :travel_expense_report_wrong_dates, parent: :travel_expense_report do
    date_start DateTime.now
    date_end 8.days.ago
  end

  factory :travel_expense_report_negative_advance, parent: :travel_expense_report do
    general_advance -10
  end
end
