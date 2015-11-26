# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notification < ActiveRecord::Base
  belongs_to :user
end
