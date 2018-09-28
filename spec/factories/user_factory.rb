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
#  personnel_number          :integer
#  remaining_leave           :integer          default(28)
#  remaining_leave_last_year :integer          default(0)
#  superadmin                :boolean          default(FALSE)
#  username                  :string
#  encrypted_password        :string           default(""), not null
#  signature                 :text
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string
#  last_sign_in_ip           :string
#  event_settings            :string
#  include_comments          :integer          default(2)
#

FactoryGirl.define do
  
  USER_NAMES ||= ['Alice', 'Bob', 'Carol', 'Dave', 'Eve', 'Frank']
  
  factory :user do
    # sequence starts with n=1
    sequence(:first_name) { |n| USER_NAMES[(n.to_i - 1) % USER_NAMES.length] }
    last_name           'Doe'
    sequence(:email)    { |n| "#{first_name}#{n}@example.com" }
    #email { "#{first_name + }@example.com" }
    language            'en'
    username {first_name}
    password '1234'
  end

  factory :hiwi, parent: :user do
    transient do
      chair nil
      responsible nil
      create_contract true
    end
    projects {build_list :project, 1}
    after(:create) do |user, evaluator|
      if evaluator.responsible and evaluator.responsible.is_a? User
        responsible = evaluator.responsible
      end
      if evaluator.create_contract
        chair = evaluator.chair
        if not chair
          if responsible
            chair = responsible.chair
          else
            chair = FactoryGirl.create(:chair)
          end
        end
        if responsible
          FactoryGirl.create(:contract, hiwi: user, chair: chair, responsible: evaluator.responsible)
        else
          FactoryGirl.create(:contract, hiwi: user, chair: chair)
        end
      end
    end
  end
end
