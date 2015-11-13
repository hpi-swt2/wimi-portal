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

class Holiday < ActiveRecord::Base
  belongs_to :users
end
