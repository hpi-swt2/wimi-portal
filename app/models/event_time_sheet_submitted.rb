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

class EventTimeSheetSubmitted < Event
  before_save :set_defaults
  belongs_to :target, class_name: 'Project'
  belongs_to :trigger, class_name: 'TimeSheet'

  def set_defaults
    self.seclevel = :wimi
    self.type = 'EventTimeSheetSubmitted'
  end
end
