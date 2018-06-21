# == Schema Information
#
# Table name: holidays
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  start                    :date
#  end                      :date
#  status                   :integer          default(0), not null
#  replacement_user_id      :integer
#  length                   :integer
#  signature                :boolean
#  last_modified            :date
#  reason                   :string
#  annotation               :string
#  length_last_year         :integer          default(0)
#  user_signature           :text
#  representative_signature :text
#  user_signed_at           :date
#  representative_signed_at :date
#

FactoryBot.define do
  factory :holiday, class: 'Holiday' do
    user_id 1
    start Date.today.at_beginning_of_week
    self.end (Date.today.at_beginning_of_week + 1)
    length 1
    last_modified Date.today
  end
end
