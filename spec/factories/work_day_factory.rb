# == Schema Information
#
# Table name: work_days
#
#  id            :integer          not null, primary key
#  date          :date
#  start_time    :time
#  break         :integer
#  end_time      :time
#  notes         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  time_sheet_id :integer
#  project_id    :integer
#  status        :string
#

FactoryGirl.define do
  factory :work_day, class: 'WorkDay' do |f|
    f.start_time Time.now.middle_of_day
    f.break 0
    f.end_time Time.now.middle_of_day + 2.hours
    f.notes 'some note'
    f.time_sheet
    f.project nil
    f.status ''
    f.date { Date.new(time_sheet.year, time_sheet.month, 1)}
    after(:build) do |wd, evaluator|
      if wd.user.projects.empty?
        project = FactoryGirl.create(:project, chair: wd.contract.chair)
        project.users << wd.user
      end
      wd.project = wd.user.projects.first if wd.project == nil
    end
    after(:create) do |wd, evaluator|
      wd.reload
      unless wd.time_sheet.work_days.count < 2
        max_date = wd.date
        date_conflict = false
        wd.time_sheet.work_days.each do |work_day|
          if max_date < work_day.date
            max_date = work_day.date
          end
          if wd.date == work_day.date and wd.id != work_day.id
            date_conflict = true
          end
        end
        wd.date = max_date + 1 if date_conflict and max_date < max_date.at_end_of_month
        wd.save
      end
    end
  end
end
