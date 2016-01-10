class EventTimeSheetAccepted < Event
  before_save :set_defaults
  belongs_to :target, class_name: 'User'
  belongs_to :trigger, class_name: 'TimeSheet'

  def set_defaults
      self.seclevel = :hiwi
      self.type = "EventTimeSheetAccepted"
  end
end
