class EventTimeSheetSubmitted < Event
  before_save :set_defaults
  belongs_to :target, class_name: 'Project'
  belongs_to :trigger, class_name: 'TimeSheet'

  def set_defaults
      self.seclevel = :wimi
      self.type = "EventTimeSheetSubmitted"
  end
end
