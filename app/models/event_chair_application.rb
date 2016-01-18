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

class EventChairApplication < Event
    before_validation :set_defaults

    def set_defaults
      self.seclevel = :admin
      self.type = 'EventChairApplication'
    end
  end
