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
<<<<<<< HEAD
#  handed_in             :boolean          default(FALSE)
#  rejection_message     :text             default("")
#  signed                :boolean          default(FALSE)
#  last_modified         :date
#  status                :integer          default(0)
#  signer                :integer
=======
>>>>>>> team3review
#

class TimeSheet < ActiveRecord::Base
    belongs_to :user
    belongs_to :project
    enum status: [ :pending, :accepted, :rejected]

    validates :workload_is_per_month, inclusion: { in: [true, false] }
    validates :salary_is_per_month, inclusion: { in: [true, false] }

    def hand_in(user)
      params = {status: 'pending', handed_in: true, last_modified: Date.today}
    end

<<<<<<< HEAD
    def sign(user)
      params = {status: 'accepted', last_modified: Date.today, signer: user.id}
    end
=======
    validates :workload_is_per_month, inclusion: { in: [true, false] }
    validates :salary_is_per_month, inclusion: { in: [true, false] }
>>>>>>> team3review

    def reject(user)
      params = {status: 'rejected', handed_in: false, last_modified: Date.today, signer: user.id}
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
