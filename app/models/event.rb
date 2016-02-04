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

class Event < ActiveRecord::Base
  belongs_to :chair
  belongs_to :trigger, class_name: 'User'

  validates :type, presence: true
  validates :seclevel, presence: true

  #after_save :send_mail

  enum seclevel: [:superadmin, :admin, :representative, :wimi, :hiwi, :user]

  def is_hidden_by(user)
    UserEvent.exists?(user: user, event: self)
  end

  def hide_for(user)
    UserEvent.create(user: user, event: self) unless is_hidden_by(user)
  end

  def send_mail
    event = Event.find(id)
    User.all.each do |user|
      results = user.create_notification_arrays
      if (results[0].include? event) || (results[1].include? event)
        MailNotifier.notification(event, user).deliver_now
      end
    end
  end

end
