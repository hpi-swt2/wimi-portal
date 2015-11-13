# == Schema Information
#
# Table name: holidays
#
#  id         :integer          not null, primary key
#  status     :string
#  start      :datetime
#  end        :datetime
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Holiday, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
