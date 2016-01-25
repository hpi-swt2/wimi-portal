# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  trigger_id :integer
#  target_id  :integer
#  chair_id   :integer
#  seclevel   :integer
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :string
#

FactoryGirl.define do
  factory :event, class: 'Event' do
    trigger_id 1
    seclevel :admin
    type 'EventUserChair'
    chair {FactoryGirl.create(:chair)}
  end
end
