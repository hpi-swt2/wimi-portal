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
<<<<<<< HEAD
#  wimi_signed           :boolean          default(FALSE)
#  hand_in_date          :date
=======
>>>>>>> team3review
#

class TimeSheet < ActiveRecord::Base
    belongs_to :user
    belongs_to :project
    enum status: [ :pending, :accepted, :rejected]

    validates :workload_is_per_month, inclusion: { in: [true, false] }
    validates :salary_is_per_month, inclusion: { in: [true, false] }

    def sum_hours
      hour_counter = 0
      monthyearrange = Date.new(self.year, self.month, 1)..Date.new(self.year, self.month, Time.days_in_month(self.month, self.year))
      WorkDay.where(date: monthyearrange, project: self.project_id, user_id: self.user_id).each do |day| 
        hour_counter = hour_counter + day.duration 
      end
      return hour_counter
    end
    
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
    sheet = TimeSheet.create!({year: year, month: month, project_id: project.id, user_id: user, workload_is_per_month: true, salary_is_per_month: true})
    return sheet
  end
end
