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

FactoryGirl.define do
  factory :chair do
    transient do
      representative true
    end
    name 'TestChair'
    after(:create) do |chair, evaluator|
      if evaluator.representative
        r = evaluator.representative
        if r.is_a? User
          FactoryGirl.create(:wimi, chair: chair, user: r, representative: true)
        else
          FactoryGirl.create(:wimi, chair: chair, representative: true)
        end
        chair.reload
      end
    end
  end
end
