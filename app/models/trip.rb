# == Schema Information
#
# Table name: trips
#
#  id         :integer          not null, primary key
#  title      :string
#  start      :datetime
#  end        :datetime
#  status     :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Trip < ActiveRecord::Base
  belongs_to :user
  has_many :expenses
  enum status: [ :saved, :applied, :accepted, :declined ]

  validates_length_of :title, minimum: 1,  allow_blank: false
end
