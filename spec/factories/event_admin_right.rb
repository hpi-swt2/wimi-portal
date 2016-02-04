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
  factory :event_admin_right do
    trigger_id 1
    target_id 1
    seclevel :user
    type 'EventAdminRight'
  end
end
