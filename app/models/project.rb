class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :publications
  has_many :expenses
  has_many :project_applications, dependent: :destroy
end
