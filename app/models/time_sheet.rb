# == Schema Information
#
# Table name: time_sheets
#
#  id                    :integer          not null, primary key
#  month                 :integer
#  year                  :integer
#  salary                :integer
#  salary_is_per_month   :boolean
#  workload              :integer
#  workload_is_per_month :boolean
#  user_id               :integer
#  project_id            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  handed_in             :boolean          default(FALSE)
#  rejection_message     :text             default("")
#  signed                :boolean          default(FALSE)
#  last_modified         :date
#  status                :integer          default(0)
#  signer                :integer
#

class TimeSheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :workload_is_per_month, inclusion: {in: [true, false]}
  validates :salary_is_per_month, inclusion: {in: [true, false]}

  def self.time_sheet_for(year, month, project, user)
    if project.nil?
      return nil
    else
      sheets = TimeSheet.where(year: year, month: month, project: project, user: user)
      if sheets.empty?
        return create_new_time_sheet(year, month, project, user)
      else
        return sheets.first
      end
    end
  end

  def self.create_new_time_sheet(year, month, project, user)
    sheet = TimeSheet.create!({year: year, month: month, project: project, user: user, workload_is_per_month: true, salary_is_per_month: true})
    return sheet
  end
end
