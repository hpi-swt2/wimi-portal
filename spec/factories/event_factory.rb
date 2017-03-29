# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  target_user_id :integer
#  object_id      :integer
#  object_type    :string
#  created_at     :datetime
#  type           :integer
#

FactoryGirl.define do
  factory :event do
    user
    target_user { user }
    object { FactoryGirl.create(:project) }
    type 'project_create'
  end
end
