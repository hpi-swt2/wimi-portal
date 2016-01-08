FactoryGirl.define do
  factory :wimi, class: "User" do
    first_name          "John"
    last_name           "Doe"
    sequence(:email)    { |n| "person#{n}@example.com" }
    projects            {build_list :project, 1}
    chair               {FactoryGirl.create(:chair)}

    after(:create) do |user|
      user.chair_wimi.update(application: "accepted")
    end
  end
end
