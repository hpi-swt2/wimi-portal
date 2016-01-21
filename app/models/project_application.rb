# == Schema Information
#
# Table name: project_applications
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectApplication < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates_presence_of :user
  validates_presence_of :project

  enum status: [:pending, :accepted, :declined]

  before_create :default_values

  private

  def default_values
    self.status ||= :pending
  end
end
