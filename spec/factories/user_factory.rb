# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string           default(""), not null
#  first_name                :string
#  last_name                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  identity_url              :string
#  language                  :string           default("en"), not null
#  street                    :string
#  personnel_number          :integer          default(0)
#  remaining_leave           :integer          default(28)
#  remaining_leave_last_year :integer          default(0)
#  superadmin                :boolean          default(FALSE)
#  username                  :string
#  encrypted_password        :string           default(""), not null
#  city                      :string
#  zip_code                  :string
#  signature                 :text
#  email_notification        :boolean          default(FALSE)
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string
#  last_sign_in_ip           :string
#

FactoryGirl.define do
  
  NAMES = ['Alice', 'Bob', 'Carol', 'Dave', 'Eve', 'Frank']
  
  factory :user do
    sequence(:first_name) { |n| NAMES[n.to_i % NAMES.length] }
    last_name           'Doe'
    sequence(:email)    { |n| "user#{n}@example.com" }
    language            'en'
  end
end
