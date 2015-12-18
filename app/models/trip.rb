# == Schema Information
#
# Table name: trips
#
#  id          :integer          not null, primary key
#  destination :string
#  reason      :text
#  annotation  :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :integer          default(0)
#  signature   :boolean
#

class Trip < ActiveRecord::Base
  belongs_to :users
  has_many :expenses

  validates_length_of :title, minimum: 1,  allow_blank: false
end
