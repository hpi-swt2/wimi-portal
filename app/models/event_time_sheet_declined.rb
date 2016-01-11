class EventTimeSheetDeclined < Event
  before_save :set_defaults
  belongs_to :user, foreign_key: 'target_id'
  belongs_to :time_sheet, foreign_key: 'trigger_id'

  def set_defaults
      self.seclevel = :hiwi
      self.type = "EventTimeSheetDeclined"
  end
end
