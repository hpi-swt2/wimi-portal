# == Schema Information
#
# Table name: travel_expense_reports
#
#  id                       :integer          not null, primary key
#  inland                   :boolean
#  country                  :string
#  location_from            :string
#  location_via             :string
#  location_to              :string
#  reason                   :text
#  date_start               :datetime
#  date_end                 :datetime
#  car                      :boolean
#  public_transport         :boolean
#  vehicle_advance          :boolean
#  hotel                    :boolean
#  status                   :integer          default(0)
#  general_advance          :integer
#  user_id                  :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  signature                :boolean
#  user_signature           :text
#  representative_signature :text
#

require 'rails_helper'

RSpec.describe TravelExpenseReport, type: :model do
  before :each do
    @report = FactoryGirl.create(:travel_expense_report, user: FactoryGirl.create(:user))
  end

  context 'with valid input' do
    it 'creates a valid report' do
      expect(TravelExpenseReport.first).to eq(@report)
    end
    it 'has access to name of the user' do
      expect(@report.first_name).to eq(User.first.first_name)
      expect(@report.last_name).to eq(User.first.last_name)
    end
    it 'has access to signature of the user' do
      expect(@report.get_signature).to eq(User.first.signature)
    end
  end

  context 'with invalid input' do
    it 'rejects wrong dates' do
      expect(FactoryGirl.build(:travel_expense_report_wrong_dates).valid?).to be false
    end
    it 'rejects negative advances' do
      expect(FactoryGirl.build(:travel_expense_report_negative_advance).valid?).to be false
    end
  end
end
