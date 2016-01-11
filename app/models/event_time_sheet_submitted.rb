class EventTimeSheetSubmitted < Event
  before_save :set_defaults
  belongs_to :project, foreign_key: 'target_id'
  belongs_to :time_sheet, foreign_key: 'trigger_id'

  def set_defaults
      self.seclevel = :wimi
      self.type = "EventTimeSheetSubmitted"
  end
end
