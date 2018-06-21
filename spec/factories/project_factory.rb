# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  description    :string           default("")
#  status         :boolean          default(TRUE)
#  chair_id       :integer
#  project_leader :string           default("")
#

FactoryBot.define do

  PROJECT_NAMES ||= ['Website Development', 'Database Maintenance', 'Cooking Coffee', 'Accounting', 'In-Database-Memory']

  factory :project, class: 'Project' do
    sequence(:title) { |n| PROJECT_NAMES[(n.to_i - 1) % PROJECT_NAMES.length]}
    chair
  end
end
