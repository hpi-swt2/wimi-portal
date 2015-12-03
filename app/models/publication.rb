# == Schema Information
#
# Table name: publications
#
#  id         :integer          not null, primary key
#  title      :string
#  venue      :string
#  type_      :string
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Publication < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_one :project

  validates_length_of :title, minimum: 1,  allow_blank: false
  validates_length_of :venue, minimum: 1,  allow_blank: false
  validates_length_of :type_, minimum: 1,  allow_blank: false
end
