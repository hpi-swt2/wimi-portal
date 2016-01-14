class EventUserChair < Event
    before_save :set_defaults
    belongs_to :target, class_name: 'User',foreign_key: 'user_id'

    def set_defaults
      self.seclevel = :admin
      self.type = 'EventUserChair'
    end
  end
