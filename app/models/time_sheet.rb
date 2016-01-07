class TimeSheet < ActiveRecord::Base
    belongs_to :user
    belongs_to :project

    validates :workload_is_per_month, :inclusion => { :in => [true, false] }
    validates :salary_is_per_month, :inclusion => { :in => [true, false] }

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
      sheet = TimeSheet.create!({year: year, month: month, project_id: project.id, user_id: user.id, workload_is_per_month: true, salary_is_per_month: true})
      return sheet
    end
end
