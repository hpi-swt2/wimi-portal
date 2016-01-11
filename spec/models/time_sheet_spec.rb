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
#  rejection_message     :text
#  signed                :boolean          default(FALSE)
#  last_modified         :date
#  status                :integer          default(0)
#  signer                :integer
#

require 'rails_helper'

RSpec.describe TimeSheet, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
