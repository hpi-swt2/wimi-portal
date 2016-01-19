# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  trigger_id :integer
#  target_id  :integer
#  chair_id   :integer
#  seclevel   :integer
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :string
#

class EventRequest < Event
  before_validation :set_defaults

  def set_defaults
    self.seclevel = :representative
    self.type = 'EventRequest'
  end
end
