class TimeSheet < ActiveRecord::Base
    belongs_to :user
    belongs_to :project

    validates :workload_is_per_month, :inclusion => { :in => [true, false] }
    validates :salary_is_per_month, :inclusion => { :in => [true, false] }
end
