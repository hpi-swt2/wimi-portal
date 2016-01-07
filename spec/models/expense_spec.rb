# == Schema Information
#
# Table name: expenses
#
#  id         :integer          not null, primary key
#  amount     :decimal(, )
#  purpose    :text
#  comment    :text
#  user_id    :integer
#  project_id :integer
#  trip_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer          default(0)
#

require 'rails_helper'

RSpec.describe Expense, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
