FactoryGirl.define do
  factory :event_project_invitation do
    trigger 0
    target 0
    seclevel :hiwi
    type "EventProjectInvitation"
  end
end
