<<<<<<< HEAD
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
#

FactoryGirl.define do
  factory :event do
    trigger_id 1
    target_id 1
    seclevel :user
    type "Event"
  end
end

#FactoryGirl.define do
#  factory :event, class: 'Event' do
#    trigger_id 1
#    seclevel :admin
#    type 'EventUserChair'
#    chair {FactoryGirl.create(:chair)}
#    end
#end
