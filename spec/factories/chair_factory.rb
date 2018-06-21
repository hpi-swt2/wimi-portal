# == Schema Information
#
# Table name: chairs
#
#  id           :integer          not null, primary key
#  name         :string
#  abbreviation :string
#  description  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do

  CHAIR_NAMES ||= ['EPIC', 'INTERNET']
  CHAIR_DESCRIPTIONS ||= ['Enterprise Platform and Integration Concepts','Internet-Technologien und -Systeme']

  factory :chair do
    transient do
      representative true
    end
    sequence(:name) { |n| CHAIR_NAMES[(n.to_i - 1) % CHAIR_NAMES.length] }
    sequence(:description) { |n| CHAIR_DESCRIPTIONS[(n.to_i - 1) % CHAIR_DESCRIPTIONS.length] }
    after(:create) do |chair, evaluator|
      if evaluator.representative
        r = evaluator.representative
        if r.is_a? User
          FactoryBot.create(:wimi, chair: chair, user: r, representative: true)
        else
          FactoryBot.create(:wimi, chair: chair, representative: true)
        end
        chair.reload
      end
    end
  end
end
