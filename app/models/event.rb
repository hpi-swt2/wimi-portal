# == Schema Information
#
# Table name: events
#
# id          :integer      not null, primary key
# trigger     :integer      foreign key 
# target      :integer      foreign key
# chair       :integer      foreign key
# seclevel    :integer     
# type        :string       
class Event < ActiveRecord::Base
  belongs_to :chair
  belongs_to :trigger, class_name: 'User', foreign_key: 'user_id'

  validates :type, presence: true
  validates :seclevel, presence: true

  enum seclevel: [:superadmin, :admin, :representative, :wimi, :hiwi, :user]

  def is_hidden_by(user)
    UserEvent.exists?(user: user, event: self)
  end

  def hide_for(user)
    UserEvent.create(user: user, event: self) unless is_hidden_by(user)
  end
end
