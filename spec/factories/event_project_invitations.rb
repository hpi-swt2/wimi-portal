FactoryGirl.define do
  factory :event_project_invitation do
    trigger_id 1
    target_id 1
    seclevel :hiwi
    type 'EventProjectInvitation'
  end
end
