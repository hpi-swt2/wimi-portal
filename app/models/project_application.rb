# == Schema Information
#
# Table name: project_applications
#
# id          :integer
# project_id  :integer
# user_id     :integer
# status      :integer    default: 1
#
#
#


class ProjectApplication < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates_presence_of :user
  validates_presence_of :project

  enum status: [ :pending, :accepted, :declined]

  before_create :default_values

  private
    def default_values
      self.status ||= :pending
    end
end
