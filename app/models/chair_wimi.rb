# == Schema Information
#
# Table name: chair_wimis
#
#  id             :integer          not null, primary key
#  admin          :boolean          default(FALSE)
#  representative :boolean          default(FALSE)
#  application    :string
#  user_id        :integer
#  chair_id       :integer
#

class ChairWimi < ActiveRecord::Base
  belongs_to :user
  belongs_to :chair
  validates :user, :chair, presence: true

  def remove(current_user)
    if current_user == user || representative
      return false
    end
    destroy
  end

  def withdraw_admin(current_user)
    if current_user == user || chair.chair_wimis.count == 1
      return false
    else
      self.admin = false
      save
    end
  end

  def is_admin?
    admin
  end

  def is_representative?
    representative
  end
end
