FactoryGirl.define do
  factory :event, class: 'Event' do
    trigger_id 1
    seclevel :admin
    type 'EventUserChair'
    chair {FactoryGirl.create(:chair)}
    end
end
