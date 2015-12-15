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
#  signed                :boolean          default(FALSE)
#  handed_in             :boolean          default(FALSE)
#  last_modified         :date
#  status                :integer          default(0)
#  signer                :integer
#

class TimeSheet < ActiveRecord::Base
    belongs_to :user
    belongs_to :project
    enum status: [ :pending, :accepted, :rejected]

  def show_add_signature_prompt
    flash[:error] = 'Please add signature'
  end
end
